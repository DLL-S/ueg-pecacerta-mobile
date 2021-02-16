import 'dart:convert';

List<Categoria> categoriaFromJson(String str) =>
    List<Categoria>.from(json.decode(str).map((x) => Categoria.fromJson(x)));

String categoriaToJson(List<Categoria> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Categoria {
  int codigo;
  String nome;

  Categoria({
    this.codigo,
    this.nome,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) =>
      Categoria(codigo: json["codigo"], nome: json["nome"]);

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nome": nome,
      };
}
