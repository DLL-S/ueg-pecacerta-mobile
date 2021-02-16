import 'dart:convert';

List<Marca> marcaFromJson(String str) =>
    List<Marca>.from(json.decode(str).map((x) => Marca.fromJson(x)));

String categoriaToJson(List<Marca> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Marca {
  int codigo;
  String nome;

  Marca({
    this.codigo,
    this.nome,
  });

  factory Marca.fromJson(Map<String, dynamic> json) =>
      Marca(codigo: json["codigo"], nome: json["nome"]);

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "nome": nome,
      };
}
