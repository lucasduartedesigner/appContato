import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/pessoa.dart';

class StorageService {
  static const String _chave = 'pessoas';

  static Future<List<Pessoa>> getPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final dadosJson = prefs.getString(_chave);
    if (dadosJson == null) return [];

    final lista = json.decode(dadosJson) as List;
    return lista.map((item) => Pessoa.fromJson(item)).toList();
  }

  static Future<void> salvarPessoas(List<Pessoa> pessoas) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(pessoas.map((p) => p.toJson()).toList());
    await prefs.setString(_chave, jsonString);
  }
}
