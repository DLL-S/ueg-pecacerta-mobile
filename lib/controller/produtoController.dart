import 'dart:convert';

import 'package:peca_certa_app/models/Produto.dart';
import 'package:http/http.dart' as http;

const String request = "https://pecacerta-api.herokuapp.com/api/v1/produtos";

class ProdutoController {
  Future<List<Produto>> listaProdutos() async {
    try {
      List<Produto> listaProdutos = List();
      final response = await http.get(request);

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        decodeJson.forEach((item) => listaProdutos.add(Produto.fromJson(item)));
        return listaProdutos;
      } else {
        print("Erro ao carregar lista de produtos");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  ProdutoController();
}
