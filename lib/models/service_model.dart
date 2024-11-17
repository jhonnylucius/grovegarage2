class Service {
  final String id;
  final String name;
  final double price;
  final String description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Service.fromMap(Map<String, dynamic> data, String id) {
    return Service(
      id: id,
      name: data['nome'] ?? '',
      price: data['preco']?.toDouble() ?? 0.0,
      description: data['descricao'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'preco': price,
      'descricao': description,
    };
  }
}
