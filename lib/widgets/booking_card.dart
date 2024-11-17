// lib/widgets/booking_card.dart
import 'package:flutter/material.dart';

class Booking {
  final String clientName;
  final String service;
  final String dateTime;
  final String status;

  Booking({
    required this.clientName,
    required this.service,
    required this.dateTime,
    required this.status,
  });
}

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          booking.clientName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Service: ${booking.service}\nDate: ${booking.dateTime}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(booking.status),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            booking.status,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
