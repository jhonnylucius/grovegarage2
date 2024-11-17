class User {
  final String id;
  final String name;
  final String email;
  final String userType; // "cliente" ou "empresa"
  final String? phone; // Opcional
  final String? companyName; // Para empresas
  final String? cnpj; // Para empresas
  final String? address; // Endereço
  final String? city; // Cidade

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    this.phone,
    this.companyName,
    this.cnpj,
    this.address,
    this.city,
  });

  factory User.fromMap(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      name: data['nome'] ?? '',
      email: data['email'] ?? '',
      userType: data['tipo-cadastro'] ?? 'cliente',
      phone: data['telefone'],
      companyName: data['razaosocial'],
      cnpj: data['cnpj'],
      address: data['endereco'],
      city: data['cidade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': name,
      'email': email,
      'tipo-cadastro': userType,
      'telefone': phone,
      'razaosocial': companyName,
      'cnpj': cnpj,
      'endereco': address,
      'cidade': city,
    };
  }
}
