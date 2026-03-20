class Usuario {
  final String id;
  final String nome;
  final String email;
  final String role; // 'user', 'superuser', 'admin'

  Usuario({required this.id, required this.nome, required this.email, required this.role});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'],
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }
}