import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';
import '../pages/detalhes_page.dart';

class SaidaPage extends StatefulWidget {
  @override
  _SaidaPageState createState() => _SaidaPageState();
}

class _SaidaPageState extends State<SaidaPage> {
  List<Pessoa> pessoas = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  void _carregarDados() async {
    final lista = await StorageService.obterPessoas();
    setState(() {
      pessoas = lista;
    });
  }

  void _excluirContato(Pessoa pessoa) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar Exclusão"),
          content: Text("Você tem certeza que deseja excluir ${pessoa.nome}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );

    if (confirmacao == true) {
      setState(() {
        pessoas.remove(pessoa);
        StorageService.salvarLista(pessoas);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saída de Dados")),
      body: ListView.builder(
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final pessoa = pessoas[index];
          return Dismissible(
            key: Key(pessoa.nome), // Use um identificador único
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _excluirContato(pessoa);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${pessoa.nome} excluído com sucesso")),
              );
            },
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text(pessoa.nome),
              subtitle: Text("Idade: ${pessoa.idade}"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesPage(pessoa: pessoa),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
