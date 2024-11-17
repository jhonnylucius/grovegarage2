import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  bool isBarbearia = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: Text('Entrar como Lava-Jato'),
              value: isBarbearia,
              onChanged: (value) {
                setState(() {
                  isBarbearia = value;
                });
              },
            ),
            _buildTextField(
              controller: _emailController,
              label: 'E-mail',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              controller: _passwordController,
              label: 'Senha',
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _loginUser,
              child: Text('Entrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/signup');
              },
              child: Text('Criar conta'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/reset_password');
              },
              child: Text('Redefinir senha'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
    );
  }

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar('Por favor, insira email e senha.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final userCredential =
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _validateUserType(userCredential.user!.email!);
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message ?? 'Erro ao fazer login.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _validateUserType(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showSnackbar('Usuário não encontrado.');
        _auth.signOut();
        return;
      }

      final userDoc = querySnapshot.docs.first;
      final tipoCadastro = userDoc['tipo-cadastro'] as String;
      final nome = tipoCadastro == 'cliente'
          ? userDoc['nome'] as String
          : userDoc['razaosocial'] as String;

      if ((isBarbearia && tipoCadastro == 'lava-jato') ||
          (!isBarbearia && tipoCadastro == 'cliente')) {
        Navigator.of(context).pushReplacementNamed(
          '/home',
          arguments: {
            'NomeUsuario': nome,
            'Email': email,
            'TipoCadastro': tipoCadastro,
          },
        );
      } else {
        _showSnackbar('Tipo de cadastro inválido.');
        _auth.signOut();
      }
    } catch (e) {
      _showSnackbar('Erro ao validar tipo de usuário: $e');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
