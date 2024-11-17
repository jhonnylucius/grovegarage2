import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  String nome = '';
  String razaoSocial = '';
  String telefone = '';
  String cnpj = '';
  String cidade = '';
  String endereco = '';
  String email = '';
  String senha = '';
  bool isBarbearia = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SwitchListTile(
                title: Text('Cadastro como Lava-Jato'),
                value: isBarbearia,
                onChanged: (value) {
                  setState(() {
                    isBarbearia = value;
                  });
                },
              ),
              if (isBarbearia)
                _buildTextField(
                  label: 'Razão Social',
                  onChanged: (value) => razaoSocial = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Razão Social é obrigatória' : null,
                ),
              if (!isBarbearia)
                _buildTextField(
                  label: 'Nome',
                  onChanged: (value) => nome = value,
                  validator: (value) => value!.isEmpty ? 'Nome é obrigatório' : null,
                ),
              _buildTextField(
                label: 'Telefone',
                onChanged: (value) => telefone = value,
                validator: (value) =>
                value!.isEmpty ? 'Telefone é obrigatório' : null,
              ),
              if (isBarbearia)
                _buildTextField(
                  label: 'CNPJ',
                  onChanged: (value) => cnpj = value,
                  validator: (value) => value!.isEmpty ? 'CNPJ é obrigatório' : null,
                ),
              _buildTextField(
                label: 'Cidade',
                onChanged: (value) => cidade = value,
                validator: (value) =>
                value!.isEmpty ? 'Cidade é obrigatória' : null,
              ),
              if (isBarbearia)
                _buildTextField(
                  label: 'Endereço',
                  onChanged: (value) => endereco = value,
                  validator: (value) =>
                  value!.isEmpty ? 'Endereço é obrigatório' : null,
                ),
              _buildTextField(
                label: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => email = value,
                validator: (value) =>
                value!.isEmpty ? 'E-mail é obrigatório' : null,
              ),
              _buildTextField(
                label: 'Senha',
                obscureText: true,
                onChanged: (value) => senha = value,
                validator: (value) =>
                value!.length < 6 ? 'Senha deve ter pelo menos 6 caracteres' : null,
              ),
              SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _registerUser,
                child: Text('Cadastrar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/login');
                },
                child: Text('Já tem uma conta? Faça login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userCredential =
      await _auth.createUserWithEmailAndPassword(email: email, password: senha);

      final userData = {
        'email': email,
        'tipoCadastro': isBarbearia ? 'lava-jato' : 'cliente',
        if (isBarbearia) ...{
          'razaoSocial': razaoSocial,
          'cnpj': cnpj,
          'endereco': endereco,
        } else ...{
          'nome': nome,
          'telefone': telefone,
          'cidade': cidade,
        },
      };

      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set(userData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Usuário cadastrado com sucesso!'),
      ));

      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao cadastrar: $e'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
