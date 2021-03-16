import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Orcamento.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:http/http.dart' as http;

const String request =
    "https://pecacerta-api-hml.herokuapp.com/api/v1/orcamentos";
const headers = {'Content-Type': 'application/json'};

class OrcamentoController {
  OrcamentoController();

//Adicionar Orcamento
  Future<APIResponse<bool>> incluirOrcamento(Orcamento item) async {
    return await http
        .post(request, headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        print(data.body);

        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Consultar Orçamento pelo ID
  Future<APIResponse<Produto>> consultaOrcamentoID(String codigo) {
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

//Alterar Orcamento pelo ID
  Future<APIResponse<bool>> alterarOrcamento(Orcamento item) async {
    return await http
        .put(request + "/" + item.codigo.toString(),
            headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      print(data.body);
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Listar Orçamentos
  Future<APIResponse<List<Orcamento>>> listarOrcamentos() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Orcamento>[];

        for (var item in jsonData) {
          produtos.add(Orcamento.fromJson(item));
        }

        return APIResponse<List<Orcamento>>(data: produtos);
      }
      return APIResponse<List<Orcamento>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Orcamento>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }
}
