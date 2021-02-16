import 'dart:convert';

import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:http/http.dart' as http;

const String request = "http://192.168.1.105:8080/api/v1/";

class CategoriaController {
  Future<List<Categoria>> listaCategorias() async {
    try {
      List<Categoria> listaCategorias = List();
      final response = await http.get(request + "categoria");

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        decodeJson
            .forEach((item) => listaCategorias.add(Categoria.fromJson(item)));
        return listaCategorias;
      } else {
        print("Erro ao carregar lista de produtos");
      }
    } catch (e) {
      print(e);
    }
  }

  CategoriaController();
}
