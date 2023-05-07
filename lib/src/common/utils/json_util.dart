import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:tothem/src/models/user.dart';

/// Util Json class to handle serialization of objects and Json file reading and writing.
class JsonUtil {
  /// Gets lists of users from remote database
  Future<List<User>?> getUsuarios(String uriAdress) async {
    var client = http.Client();
    var uri = Uri.parse(uriAdress);
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      var json = response.body;
      return usuarioFromJson(json);
    }
    return null;
  }

/** METHODS TO READ LOCAL JSON 
  // Lee el archivo json local y devuelve lista de usuarios
  Future<List<Usuario>?> readLocalJson(String jsonPath) async {
    final String response = await rootBundle.loadString(jsonPath);
    return usuarioFromJson(response);
  }

  // Lee el archivo json local y devuelve lista de pagos
  Future<List<CambioPago>?> readCambioGameJson(String jsonPath) async {
    final String response = await rootBundle.loadString(jsonPath);
    return cambioPagoFromJson(response);
  }

  Future<File> writeToJson(String jsonPath, Usuario usuario) {
    // No funciona en local
    final file = File(jsonPath);
    //Future<bool> existe = File(jsonPath).exists();
    // Escribe el archivo
    return file.writeAsString(usuario.toJson().toString(),
        mode: FileMode.append, flush: false);
  }
*/
}
