import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:http/http.dart' as http;

const String request = "https://pecacerta-api.herokuapp.com/api/v1/produtos";
const headers = {'Content-Type': 'application/json'};

class ProdutoController {
  ProdutoController();

//Adicionar Produto
  Future<APIResponse<bool>> incluirProduto(Produto item) async {
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

//Consultar Produto pelo ID
  Future<APIResponse<Produto>> consultaProdutoID(String codigo) {
    return http.get(request + "/" + codigo, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Produto>(data: Produto.fromJson(jsonData));
      }
      return APIResponse<Produto>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError(
        (_) => APIResponse<Produto>(error: true, errorMessage: toString()));
  }

//Alterar Produto pelo ID
  Future<APIResponse<bool>> alterarProduto(Produto item) async {
    return await http
        .put(request + "/" + item.codigo.toString(),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Listar Produtos
  Future<APIResponse<List<Produto>>> listarProdutos() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Produto>[];

        for (var item in jsonData) {
          produtos.add(Produto.fromJson(item));
        }

        return APIResponse<List<Produto>>(data: produtos);
      }
      return APIResponse<List<Produto>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Produto>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }
}
