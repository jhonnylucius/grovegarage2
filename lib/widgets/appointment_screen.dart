import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/booking_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  String? email;
  String? userType;
  List<Map<String, dynamic>> appointments = [];

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _fetchUserData();
  }

  void _fetchUserData() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      email = currentUser.email;

      final userDoc = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .get();

      if (userDoc.docs.isNotEmpty) {
        setState(() {
          userType = userDoc.docs.first.get('tipo-cadastro');
        });
        _loadAppointments();
      }
    }
  }

  void _loadAppointments() async {
    final query = await _firestore.collection('agendamentos').get();

    setState(() {
      appointments = query.docs
          .map((doc) {
        final data = doc.data();
        if (userType == 'cliente' && data['email'] == email) {
          return {'id': doc.id, ...data};
        } else if (userType == 'barbearia') {
          return {'id': doc.id, ...data};
        }
        return null;
      })
          .where((element) => element != null)
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  void _navigateToBookingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BookingScreen()),
    ).then((_) {
      _loadAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamentos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return ListTile(
                  title: Text('Horário: ${appointment['hora']}'),
                  subtitle: Text('Data: ${appointment['data']}'),
                  trailing: Text('Cliente: ${appointment['cliente']}'),
                );
              },
            ),
          ),
          FloatingActionButton(
            onPressed: _navigateToBookingScreen,
            tooltip: 'Agendar',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
