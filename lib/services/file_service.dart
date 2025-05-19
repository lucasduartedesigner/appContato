import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class FileService {
  static const String _key = 'contatos_data';

  static Future<String> get _localPath async {
    if (kIsWeb) {
      return '';
    }
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File?> get _localFile async {
    if (kIsWeb) {
      return null;
    }
    final path = await _localPath;
    return File('$path/contatos.json');
  }

  static Future<void> writeData(String data) async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_key, data);
      } else {
        final file = await _localFile;
        if (file != null) {
          await file.writeAsString(data);
        }
      }
    } catch (e) {
      print('Erro ao escrever os dados: $e');
    }
  }

  static Future<String> readData() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(_key) ?? '[]';
      } else {
        final file = await _localFile;
        if (file != null && await file.exists()) {
          return await file.readAsString();
        }
      }
      return '[]';
    } catch (e) {
      print('Erro ao ler os dados: $e');
      return '[]';
    }
  }

  static Future<String?> exportData() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final data = prefs.getString(_key) ?? '[]';
        return data;
      } else {
        final file = await _localFile;
        if (file != null && await file.exists()) {
          final data = await file.readAsString();
          return data;
        }
      }
      return null;
    } catch (e) {
      print('Erro ao exportar dados: $e');
      return null;
    }
  }

  static Future<bool> importData(String data) async {
    try {
      await writeData(data);
      return true;
    } catch (e) {
      print('Erro ao importar dados: $e');
      return false;
    }
  }
}
