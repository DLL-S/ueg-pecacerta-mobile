import 'Endereco.dart';

class Cliente {
  int codigo;
  String nome;
  String tipoCliente;
  String cpfCnpj;
  String dataDeNascimento;
  Endereco endereco;
  bool ativo;
  String email;
  String telefone;

  Cliente(
      {this.codigo,
      this.nome,
      this.tipoCliente,
      this.cpfCnpj,
      this.dataDeNascimento,
      this.endereco,
      this.ativo,
      this.email,
      this.telefone});

  Cliente.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    tipoCliente = json['tipoCliente'];
    cpfCnpj = json['cpfCnpj'];
    dataDeNascimento = json['dataDeNascimento'];
    endereco = json['endereco'] != null
        ? new Endereco.fromJson(json['endereco'])
        : null;
    ativo = json['ativo'];
    email = json['email'];
    telefone = json['telefone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['tipoCliente'] = this.tipoCliente;
    data['cpfCnpj'] = this.cpfCnpj;
    data['dataDeNascimento'] = this.dataDeNascimento;
    if (this.endereco != null) {
      data['endereco'] = this.endereco.toJson();
    }
    data['ativo'] = this.ativo;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    return data;
  }
}
