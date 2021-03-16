class Marca {
  int codigo;
  String nome;
  bool ativo;

  Marca({this.codigo, this.nome, this.ativo});

  Marca.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['ativo'] = this.ativo;
    return data;
  }
}
