import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:http/http.dart' as http;

const String request = "https://pecacerta-api.herokuapp.com/api/v1/categorias";
const headers = {'Content-Type': 'application/json'};
Categoria cat = new Categoria();

class CategoriaController {
  CategoriaController();

  Future<List<Categoria>> listaCategorias() async {
    try {
      List<Categoria> listaCategorias = List();
      final response = await http.get(request);

      if (response.statusCode == 200) {
        var decodeJson = jsonDecode(Utf8Decoder().convert(response.bodyBytes));
        decodeJson
            .forEach((item) => listaCategorias.add(Categoria.fromJson(item)));
        return listaCategorias;
      } else {
        print("Erro ao carregar lista de produtos");
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<APIResponse<bool>> incluirCategoria(Categoria item) async {
    return await http
        .post(request, headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }
}
