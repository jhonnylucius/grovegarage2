import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Coleção de agendamentos
  final String collectionName = 'agendamentos';

  // CREATE: Cria um novo agendamento
  Future<void> criarAgendamento(Map<String, dynamic> agendamentoData) async {
    try {
      await _firestore.collection(collectionName).add(agendamentoData);
      print('Agendamento criado com sucesso!');
    } catch (e) {
      print('Erro ao criar agendamento: $e');
    }
  }

  // READ: Obtém todos os agendamentos (para o painel do administrador)
  Future<List<Map<String, dynamic>>> obterTodosAgendamentos() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Erro ao obter agendamentos: $e');
      return [];
    }
  }

  // READ: Obtém agendamentos por usuário
  Future<List<Map<String, dynamic>>> obterAgendamentosPorUsuario(String email) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Erro ao obter agendamentos por usuário: $e');
      return [];
    }
  }

  // UPDATE: Atualiza um agendamento pelo ID do documento
  Future<void> atualizarAgendamento(String docId, Map<String, dynamic> novosDados) async {
    try {
      await _firestore.collection(collectionName).doc(docId).update(novosDados);
      print('Agendamento atualizado com sucesso!');
    } catch (e) {
      print('Erro ao atualizar agendamento: $e');
    }
  }

  // DELETE: Remove um agendamento pelo ID do documento
  Future<void> deletarAgendamento(String docId) async {
    try {
      await _firestore.collection(collectionName).doc(docId).delete();
      print('Agendamento removido com sucesso!');
    } catch (e) {
      print('Erro ao remover agendamento: $e');
    }
  }

  // READ: Método adicional para obter agendamentos de uma data específica (filtro adicional para o administrador)
  Future<List<Map<String, dynamic>>> obterAgendamentosPorData(String data) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('data', isEqualTo: data)
          .get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      print('Erro ao obter agendamentos por data: $e');
      return [];
    }
  }
}
