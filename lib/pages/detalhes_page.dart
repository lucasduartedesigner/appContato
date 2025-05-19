import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';

class ResumoPage extends StatefulWidget {
  const ResumoPage({super.key});

  @override
  _ResumoPageState createState() => _ResumoPageState();
}

class _ResumoPageState extends State<ResumoPage> {
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    final dados = await StorageService.getPessoas();
    setState(() {
      pessoas = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumo de Pessoas'),
      ),
      body: ListView.builder(
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final pessoa = pessoas[index];
          return ListTile(
            leading: const Icon(Icons.person),
            title: Text(pessoa.nome),
            subtitle: Text('Idade: ${pessoa.idade}'),
          );
        },
      ),
    );
  }
}

class DetalhesPage extends StatelessWidget {
  final Pessoa pessoa;

  const DetalhesPage({super.key, required this.pessoa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do Contato')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${pessoa.nome}', style: const TextStyle(fontSize: 18)),
            Text('Email: ${pessoa.email}',
                style: const TextStyle(fontSize: 18)),
            Text('Telefone: ${pessoa.telefone}',
                style: const TextStyle(fontSize: 18)),
            Text('Idade: ${pessoa.idade}',
                style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
