import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Cliente.dart';
import 'package:http/http.dart' as http;

const String request =
    "https://pecacerta-api-hml.herokuapp.com/api/v1/clientes";
const headers = {'Content-Type': 'application/json'};

class ClienteController {
  ClienteController();

//Adicionar Cliente
  Future<APIResponse<bool>> incluirCliente(Cliente cliente) async {
    return await http
        .post(request, headers: headers, body: json.encode(cliente.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Consultar Cliente pelo ID
  Future<APIResponse<Cliente>> consultaClienteID(String codigo) {
    return http.get(request + codigo, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Cliente>(data: Cliente.fromJson(jsonData));
      }
      return APIResponse<Cliente>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError(
        (_) => APIResponse<Cliente>(error: true, errorMessage: toString()));
  }

//Alterar Cliente pelo ID
  Future<APIResponse<bool>> alterarCliente(Cliente funcionario) async {
    return await http
        .put(request + "/" + funcionario.codigo.toString(),
            headers: headers, body: json.encode(funcionario.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Listar Clientes
  Future<APIResponse<List<Cliente>>> listarClientes() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Cliente>[];

        for (var item in jsonData) {
          produtos.add(Cliente.fromJson(item));
        }

        return APIResponse<List<Cliente>>(data: produtos);
      }
      return APIResponse<List<Cliente>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Cliente>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }

  //Listar Cliente Ativos
  Future<APIResponse<List<Cliente>>> listarClientesAtivos() {
    return http.get(request + "/ativos", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Cliente>[];

        for (var item in jsonData) {
          produtos.add(Cliente.fromJson(item));
        }

        return APIResponse<List<Cliente>>(data: produtos);
      }
      return APIResponse<List<Cliente>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Cliente>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }
}
