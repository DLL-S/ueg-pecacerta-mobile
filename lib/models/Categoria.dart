import 'dart:convert';

//final categoria = categoriaFromJson(jsonString);

Categoria categoriaFromJson(String str) => Categoria.fromJson(json.decode(str));

String categoriaToJson(Categoria data) => json.encode(data.toJson());

class Categoria {
  int codigo;
  String nome;
  bool ativo;

  Categoria({this.codigo, this.nome, this.ativo});

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      codigo: json['codigo'],
      nome: json['nome'],
      ativo: json['ativo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "nome": nome,
      "ativo": ativo,
    };
  }
}
