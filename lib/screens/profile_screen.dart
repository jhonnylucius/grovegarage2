import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String tipoCadastro;
  final String name;
  final String email;

  const ProfileScreen({
    super.key,
    required this.tipoCadastro,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil $tipoCadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: $name',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Tipo de Cadastro: $tipoCadastro',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
