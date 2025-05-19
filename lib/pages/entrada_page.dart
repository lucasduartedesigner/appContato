import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';

class EntradaPage extends StatefulWidget {
  const EntradaPage({super.key});

  @override
  _EntradaPageState createState() => _EntradaPageState();
}

class _EntradaPageState extends State<EntradaPage> {
  final nomeController = TextEditingController();
  final idadeController = TextEditingController();

  void _salvarDados() async {
    final nome = nomeController.text;
    final idade = int.tryParse(idadeController.text) ?? 0;

    if (nome.isEmpty || idade == 0) return;

    Pessoa novaPessoa = Pessoa(nome: nome, idade: idade);
    await StorageService.adicionarPessoa(novaPessoa);

    nomeController.clear();
    idadeController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Dados salvos com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrada de Dados")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Idade"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarDados,
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}
