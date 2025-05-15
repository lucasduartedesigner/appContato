class Pessoa {
  final String nome;
  final String telefone;
  final String email;
  final String senha;
  final int idade;

  Pessoa({
    required this.nome,
    required this.telefone,
    required this.email,
    required this.senha,
    required this.idade,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    return Pessoa(
      nome: json['nome'],
      telefone: json['telefone'],
      email: json['email'],
      senha: json['senha'],
      idade: json['idade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'telefone': telefone,
      'email': email,
      'senha': senha,
      'idade': idade,
    };
  }
}
