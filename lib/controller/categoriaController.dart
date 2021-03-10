import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:http/http.dart' as http;

const String request =
    "http://pecacerta-api-hml.herokuapp.com/api/v1/categorias";
const headers = {'Content-Type': 'application/json'};
Categoria cat = new Categoria();

class CategoriaController {
  CategoriaController();

//Adicionar Categoria
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

//Alterar Categoria
  Future<APIResponse<bool>> alterarCategoria(Categoria item) async {
    return await http
        .put(request + "/" + item.codigo.toString(),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Consultar Categoria pelo ID
  Future<APIResponse<Categoria>> consultaCategoriaID(String codigo) {
    return http.get(request + "/" + codigo, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Categoria>(data: Categoria.fromJson(jsonData));
      }
      return APIResponse<Categoria>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError(
        (_) => APIResponse<Categoria>(error: true, errorMessage: toString()));
  }

//Método para Listar categorias
  Future<APIResponse<List<Categoria>>> listarCategorias() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final categorias = <Categoria>[];

        for (var item in jsonData) {
          categorias.add(Categoria.fromJson(item));
        }
        return APIResponse<List<Categoria>>(data: categorias);
      }
      return APIResponse<List<Categoria>>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Categoria>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }

  //Método para Listar categorias ativas
  Future<APIResponse<List<Categoria>>> listarCategoriasAtivas() {
    return http.get(request + "/ativos", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final categorias = <Categoria>[];

        for (var item in jsonData) {
          categorias.add(Categoria.fromJson(item));
        }
        return APIResponse<List<Categoria>>(data: categorias);
      }
      return APIResponse<List<Categoria>>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Categoria>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }
}
