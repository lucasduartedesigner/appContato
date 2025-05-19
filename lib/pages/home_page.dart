import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';
import 'formulario_page.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  void _adicionarOuEditar({Pessoa? pessoa}) async {
    if (pessoa != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalhesPage(pessoa: pessoa),
        ),
      );
    } else {
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FormularioPage(),
        ),
      );

      if (resultado != null && resultado is Pessoa) {
        setState(() {
          pessoas.add(resultado);
          StorageService.salvarLista(pessoas);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contatos")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: pessoas.length,
        itemBuilder: (context, index) {
          final pessoa = pessoas[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(pessoa.nome,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(pessoa.email),
              onTap: () => _adicionarOuEditar(pessoa: pessoa),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditar(),
        tooltip: 'Adicionar novo contato',
        child: const Icon(Icons.add),
      ),
    );
  }
}
