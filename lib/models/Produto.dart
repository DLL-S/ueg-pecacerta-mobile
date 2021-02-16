import 'Categoria.dart';
import 'Marca.dart';
import 'dart:convert';

List<Produto> produtoFromJson(String str) =>
    List<Produto>.from(json.decode(str).map((x) => Produto.fromJson(x)));

String produtoToJson(List<Produto> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Produto {
  int codigo;
  String codigoDeBarras;
  String nome;
  String descricao;
  Categoria categoria;
  Marca marca;
  double preco;
  int qtdeEstoque;

  Produto({
    this.codigo,
    this.codigoDeBarras,
    this.nome,
    this.descricao,
    this.categoria,
    this.marca,
    this.preco,
    this.qtdeEstoque,
  });

  factory Produto.fromJson(Map<String, dynamic> json) => Produto(
      codigo: json["codigo"],
      codigoDeBarras: json["codigoDeBarras"],
      nome: json["nome"],
      descricao: json["descicao"],
      categoria: json["categoria"],
      marca: json["marca"],
      preco: json["preco"],
      qtdeEstoque: json["qtdeEstoque"]);

  Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "codigoDeBarras": codigoDeBarras,
        "nome": nome,
        "descicao": descricao,
        "categoria": categoria,
        "marca": marca,
        "preco": preco,
        "qtdeEstoque": qtdeEstoque,
      };
}
