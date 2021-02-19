import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Marca.dart';
import 'package:http/http.dart' as http;

const String request = "https://pecacerta-api.herokuapp.com/api/v1/marcas";
const headers = {'Content-Type': 'application/json'};
Marca cat = new Marca();

class MarcaController {
  MarcaController();

//Adicionar Marca
  Future<APIResponse<bool>> incluirMarca(Marca item) async {
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

//Consultar Marca pelo ID
  Future<APIResponse<Marca>> consultaMarcaID(String codigo) {
    return http.get(request + codigo, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Marca>(data: Marca.fromJson(jsonData));
      }
      return APIResponse<Marca>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError(
        (_) => APIResponse<Marca>(error: true, errorMessage: toString()));
  }

//Método para Listar marcas
  Future<APIResponse<List<Marca>>> listarMarcas() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final marcas = <Marca>[];

        for (var item in jsonData) {
          marcas.add(Marca.fromJson(item));
        }

        return APIResponse<List<Marca>>(data: marcas);
      }
      return APIResponse<List<Marca>>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError((_) =>
        APIResponse<List<Marca>>(error: true, errorMessage: "Ocorreu um erro"));
  }
}
