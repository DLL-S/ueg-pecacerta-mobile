import 'dart:convert';

import 'package:peca_certa_app/models/Produto.dart';
import 'package:http/http.dart' as http;

const String request = "http://192.168.1.105:8080/api/v1/";

class ProdutoController {
  Future<List<Produto>> listaProdutos() async {
    try {
      List<Produto> listaProdutos = List();
      final response = await http.get(request + "produtos");

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(response.body);
        decodeJson.forEach((item) => listaProdutos.add(Produto.fromJson(item)));
        return listaProdutos;
      } else {
        print("Erro ao carregar lista de produtos");
      }
    } catch (e) {
      print(e);
    }
  }

  ProdutoController();
}
