import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  String? selectedService;
  String? selectedTime;
  String? selectedProfessional;
  String clientName = '';
  String email = FirebaseAuth.instance.currentUser?.email ?? '';

  final _services = ['Lavagem Completa', 'Polimento', 'Detalhamento'];
  final _times = ['08:00', '10:00', '14:00', '16:00'];
  final _professionals = ['João', 'Maria', 'Carlos']; // Opcional

  @override
  void initState() {
    super.initState();
    _retrieveClientInfo();
  }

  void _retrieveClientInfo() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var query = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('email', isEqualTo: user.email)
          .get();

      if (query.docs.isNotEmpty) {
        setState(() {
          clientName = query.docs.first['nome'];
        });
      }
    }
  }

  void _scheduleAppointment() async {
    if (selectedService != null && selectedTime != null) {
      var appointment = {
        'data': selectedDate.toString(),
        'hora': selectedTime,
        'tipoServico': selectedService,
        'profissional': selectedProfessional,
        'cliente': clientName,
        'email': email,
      };

      await FirebaseFirestore.instance.collection('agendamentos').add(appointment);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Agendamento realizado com sucesso!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, preencha todos os campos!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agendar Serviço')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarDatePicker(
              initialDate: selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateChanged: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
            ),
            DropdownButton<String>(
              hint: Text('Escolha o Serviço'),
              value: selectedService,
              onChanged: (value) {
                setState(() {
                  selectedService = value;
                });
              },
              items: _services.map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              hint: Text('Escolha o Horário'),
              value: selectedTime,
              onChanged: (value) {
                setState(() {
                  selectedTime = value;
                });
              },
              items: _times.map((time) {
                return DropdownMenuItem(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
            DropdownButton<String>(
              hint: Text('Escolha o Profissional'),
              value: selectedProfessional,
              onChanged: (value) {
                setState(() {
                  selectedProfessional = value;
                });
              },
              items: _professionals.map((professional) {
                return DropdownMenuItem(
                  value: professional,
                  child: Text(professional),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _scheduleAppointment,
              child: Text('Agendar'),
            ),
          ],
        ),
      ),
    );
  }
}
