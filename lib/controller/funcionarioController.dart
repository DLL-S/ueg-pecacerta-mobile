import 'dart:convert';

import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Funcionario.dart';
import 'package:http/http.dart' as http;

const String request =
    "https://pecacerta-api.herokuapp.com/api/v1/funcionarios";
const headers = {'Content-Type': 'application/json'};

class FuncionarioController {
  FuncionarioController();

//Adicionar Funcionario
  Future<APIResponse<bool>> incluirFuncionario(Funcionario funcionario) async {
    return await http
        .post(request,
            headers: headers, body: json.encode(funcionario.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode.toString());
      return APIResponse<bool>(error: true, errorMessage: 'Erro');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'Erro (Exceção)'));
  }

//Consultar Funcionario pelo ID
  Future<APIResponse<Funcionario>> consultaFuncionarioID(String codigo) {
    return http.get(request + codigo, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return APIResponse<Funcionario>(data: Funcionario.fromJson(jsonData));
      }
      return APIResponse<Funcionario>(
          error: true, errorMessage: data.statusCode.toString());
    }).catchError(
        (_) => APIResponse<Funcionario>(error: true, errorMessage: toString()));
  }

//Alterar Funcionario pelo ID
  Future<APIResponse<bool>> alterarFuncionario(Funcionario funcionario) async {
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

//Listar Funcionarios
  Future<APIResponse<List<Funcionario>>> listarFuncionarios() {
    return http.get(request, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Funcionario>[];

        for (var item in jsonData) {
          produtos.add(Funcionario.fromJson(item));
        }

        return APIResponse<List<Funcionario>>(data: produtos);
      }
      return APIResponse<List<Funcionario>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Funcionario>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }

  //Listar Funcionarios Ativos
  Future<APIResponse<List<Funcionario>>> listarFuncionariosAtivos() {
    return http.get(request + "/ativos", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(Utf8Decoder().convert(data.bodyBytes));
        final produtos = <Funcionario>[];

        for (var item in jsonData) {
          produtos.add(Funcionario.fromJson(item));
        }

        return APIResponse<List<Funcionario>>(data: produtos);
      }
      return APIResponse<List<Funcionario>>(
          error: true,
          errorMessage: 'Erro: Não foi possível carregar os produtos.' +
              data.statusCode.toString());
    }).catchError((_) => APIResponse<List<Funcionario>>(
        error: true, errorMessage: "Ocorreu um erro"));
  }
}
