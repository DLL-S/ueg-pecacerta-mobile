import 'Endereco.dart';

class Funcionario {
  int codigo;
  String nome;
  String tipoDeFuncionario;
  String cpf;
  String dataNasc;
  Endereco endereco;
  String email;
  String telefone;
  bool ativo;

  Funcionario(
      {this.codigo,
      this.nome,
      this.tipoDeFuncionario,
      this.cpf,
      this.dataNasc,
      this.endereco,
      this.email,
      this.telefone,
      this.ativo});

  Funcionario.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    nome = json['nome'];
    tipoDeFuncionario = json['tipoDeFuncionario'];
    cpf = json['cpf'];
    dataNasc = json['dataNasc'];
    endereco = json['endereco'] != null
        ? new Endereco.fromJson(json['endereco'])
        : null;
    email = json['email'];
    telefone = json['telefone'];
    ativo = json['ativo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['nome'] = this.nome;
    data['tipoDeFuncionario'] = this.tipoDeFuncionario;
    data['cpf'] = this.cpf;
    data['dataNasc'] = this.dataNasc;
    if (this.endereco != null) {
      data['endereco'] = this.endereco.toJson();
    }
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    data['ativo'] = this.ativo;
    return data;
  }
}
