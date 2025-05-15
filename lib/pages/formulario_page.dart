import 'package:flutter/material.dart';
import '../models/pessoa.dart';

class FormularioPage extends StatefulWidget {
  final Pessoa? pessoa;

  FormularioPage({this.pessoa});

  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _idadeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.pessoa != null) {
      _nomeController.text = widget.pessoa!.nome;
      _telefoneController.text = widget.pessoa!.telefone;
      _emailController.text = widget.pessoa!.email;
      _senhaController.text = widget.pessoa!.senha;
      _idadeController.text = widget.pessoa!.idade.toString();
    }
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      final novaPessoa = Pessoa(
        nome: _nomeController.text,
        telefone: _telefoneController.text,
        email: _emailController.text,
        senha: _senhaController.text,
        idade: int.parse(_idadeController.text),
      );
      Navigator.pop(context, novaPessoa);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text(widget.pessoa == null ? "Novo Contato" : "Editar Contato")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                validator: (value) =>
                    value!.isEmpty ? 'Informe o telefone' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? 'Informe o email' : null,
              ),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Senha"),
                validator: (value) => value!.isEmpty ? 'Informe a senha' : null,
              ),
              TextFormField(
                controller: _idadeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Idade"),
                validator: (value) => value!.isEmpty ? 'Informe a idade' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text("Salvar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
