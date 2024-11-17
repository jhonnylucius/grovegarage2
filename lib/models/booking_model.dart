class Booking {
  final String id;
  final String date;
  final String time;
  final String serviceType;
  final String provider; // Nome do prestador de serviço
  final String clientName;
  final String clientEmail;

  Booking({
    required this.id,
    required this.date,
    required this.time,
    required this.serviceType,
    required this.provider,
    required this.clientName,
    required this.clientEmail,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      date: data['data'] ?? '',
      time: data['hora'] ?? '',
      serviceType: data['tipoServiço'] ?? '',
      provider: data['esteticaautomotiva'] ?? '',
      clientName: data['cliente'] ?? '',
      clientEmail: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': date,
      'hora': time,
      'tipoServiço': serviceType,
      'esteticaautomotiva': provider,
      'cliente': clientName,
      'email': clientEmail,
    };
  }
}
