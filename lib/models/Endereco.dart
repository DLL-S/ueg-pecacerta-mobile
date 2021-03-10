class Endereco {
  String logradouro;
  String numero;
  String complemento;
  String bairro;
  String cep;
  String cidade;
  String estado;

  Endereco(
      {this.logradouro,
      this.numero,
      this.complemento,
      this.bairro,
      this.cep,
      this.cidade,
      this.estado});

  Endereco.fromJson(Map<String, dynamic> json) {
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    bairro = json['bairro'];
    cep = json['cep'];
    cidade = json['cidade'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logradouro'] = this.logradouro;
    data['numero'] = this.numero;
    data['complemento'] = this.complemento;
    data['bairro'] = this.bairro;
    data['cep'] = this.cep;
    data['cidade'] = this.cidade;
    data['estado'] = this.estado;
    return data;
  }
}
