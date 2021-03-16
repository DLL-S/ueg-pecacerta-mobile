import 'Categoria.dart';
import 'Marca.dart';

class Produto {
  int codigo;
  String codigoDeBarras;
  String nome;
  String descricao;
  Categoria categoria;
  Marca marca;
  double preco;
  int qtdeEstoque;
  bool ativo;

  Produto(
      {this.codigo,
      this.codigoDeBarras,
      this.nome,
      this.descricao,
      this.categoria,
      this.marca,
      this.preco,
      this.qtdeEstoque,
      this.ativo});

  Produto.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    codigoDeBarras = json['codigoDeBarras'];
    nome = json['nome'];
    descricao = json['descricao'];
    categoria = json['categoria'] != null
        ? new Categoria.fromJson(json['categoria'])
        : null;
    marca = json['marca'] != null ? new Marca.fromJson(json['marca']) : null;
    preco = json['preco'];
    qtdeEstoque = json['qtdeEstoque'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['codigoDeBarras'] = this.codigoDeBarras;
    data['nome'] = this.nome;
    data['descricao'] = this.descricao;
    if (this.categoria != null) {
      data['categoria'] = this.categoria.toJson();
    }
    if (this.marca != null) {
      data['marca'] = this.marca.toJson();
    }
    data['preco'] = this.preco;
    data['qtdeEstoque'] = this.qtdeEstoque;
    data['ativo'] = this.ativo;
    return data;
  }
}
