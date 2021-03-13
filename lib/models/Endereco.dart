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
    logradouro = json['logradouro'] == null ? '-' : json['logradouro'];
    numero = json['numero'] == null ? '-' : json['numero'];
    complemento = json['complemento'] == null ? '-' : json['complemento'];
    bairro = json['bairro'] == null ? '-' : json['bairro'];
    cep = json['cep'] == null ? '-' : json['cep'];
    cidade = json['cidade'] == null ? '-' : json['cidade'];
    estado = json['estado'] == null ? '-' : json['estado'];
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
