import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';

class EntradaPage extends StatefulWidget {
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
      SnackBar(content: Text("Dados salvos com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entrada de Dados")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Idade"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text("Salvar"),
              onPressed: _salvarDados,
            )
          ],
        ),
      ),
    );
  }
}