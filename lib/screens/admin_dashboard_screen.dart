import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, dynamic>> agendamentos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgendamentos();
  }

  Future<void> _fetchAgendamentos() async {
    setState(() {
      isLoading = true;
    });
    try {
      agendamentos = await _firebaseService.obterTodosAgendamentos();
    } catch (e) {
      print('Erro ao carregar agendamentos: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteAgendamento(String docId) async {
    try {
      await _firebaseService.deletarAgendamento(docId);
      _fetchAgendamentos(); // Atualiza a lista após deletar
    } catch (e) {
      print('Erro ao deletar agendamento: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Painel Administrativo'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchAgendamentos,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: agendamentos.length,
        itemBuilder: (context, index) {
          final agendamento = agendamentos[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('Cliente: ${agendamento['cliente']}'),
              subtitle: Text(
                  'Data: ${agendamento['data']} - Hora: ${agendamento['hora']}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteAgendamento(agendamento['id']);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
