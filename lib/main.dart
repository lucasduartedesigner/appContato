import 'package:flutter/material.dart';
import 'models/pessoa.dart';
import 'pages/formulario_page.dart';
import 'pages/detalhes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Contatos',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ListaPage(),
    );
  }
}

class ListaPage extends StatefulWidget {
  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  List<Pessoa> contatos = [];

  void _adicionarOuEditarPessoa({Pessoa? pessoaExistente}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioPage(pessoa: pessoaExistente),
      ),
    );

    if (resultado != null && resultado is Pessoa) {
      setState(() {
        if (pessoaExistente != null) {
          // Edição
          final index = contatos.indexOf(pessoaExistente);
          contatos[index] = resultado;
        } else {
          // Novo
          contatos.add(resultado);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lista de Contatos")),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final pessoa = contatos[index];
          return ListTile(
            title: Text(pessoa.nome),
            subtitle: Text(pessoa.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalhesPage(pessoa: pessoa),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () =>
                  _adicionarOuEditarPessoa(pessoaExistente: pessoa),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarPessoa(),
        child: Icon(Icons.add),
      ),
    );
  }
}
