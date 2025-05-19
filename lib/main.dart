import 'package:flutter/material.dart';
import 'models/pessoa.dart';
import 'pages/formulario_page.dart';
import 'pages/detalhes_page.dart';
import 'services/file_service.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' if (dart.library.html) 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const ListaPage({super.key});

  @override
  _ListaPageState createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  List<Pessoa> contatos = [];

  @override
  void initState() {
    super.initState();
    _carregarContatos();
  }

  Future<void> _carregarContatos() async {
    final dados = await FileService.readData();
    if (dados.isNotEmpty) {
      final List<dynamic> jsonList = json.decode(dados);
      setState(() {
        contatos = jsonList.map((json) => Pessoa.fromJson(json)).toList();
      });
    }
  }

  Future<void> _salvarContatos() async {
    final jsonList = contatos.map((pessoa) => pessoa.toJson()).toList();
    await FileService.writeData(json.encode(jsonList));
  }

  Future<void> _exportarDados() async {
    try {
      final dados = await FileService.exportData();
      if (dados != null) {
        if (kIsWeb) {
          // Implementação para web
          final blob = html.Blob([dados], 'application/json');
          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement(href: url)
            ..setAttribute('download', 'contatos.json')
            ..click();
          html.Url.revokeObjectUrl(url);
        } else {
          // Implementação para dispositivos móveis
          final result = await FilePicker.platform.saveFile(
            dialogTitle: 'Salvar arquivo de contatos',
            fileName: 'contatos.json',
            type: FileType.custom,
            allowedExtensions: ['json'],
          );

          if (result != null) {
            final file = File(result);
            await file.writeAsString(dados);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dados exportados com sucesso!')),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao exportar dados: $e')),
      );
    }
  }

  Future<void> _importarDados() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        final dados = await file.readAsString();

        // Validar se é um JSON válido
        try {
          final jsonList = json.decode(dados) as List;
          final contatosImportados =
              jsonList.map((json) => Pessoa.fromJson(json)).toList();

          setState(() {
            contatos = contatosImportados;
          });
          await _salvarContatos();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dados importados com sucesso!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Arquivo inválido!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao importar dados: $e')),
      );
    }
  }

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
          final index = contatos.indexOf(pessoaExistente);
          contatos[index] = resultado;
        } else {
          contatos.add(resultado);
        }
      });
      await _salvarContatos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload),
            onPressed: _importarDados,
            tooltip: 'Importar contatos',
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportarDados,
            tooltip: 'Exportar contatos',
          ),
        ],
      ),
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
              icon: const Icon(Icons.edit),
              onPressed: () =>
                  _adicionarOuEditarPessoa(pessoaExistente: pessoa),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarOuEditarPessoa(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
