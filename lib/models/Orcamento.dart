import 'package:peca_certa_app/models/Cliente.dart';
import 'package:peca_certa_app/models/ProdutosOrcamento.dart';

class Orcamento {
  bool ativo;
  int codigo;
  Cliente cliente;
  String data;
  double valorTotal;
  String observacoes;
  List<ProdutosOrcamento> produtosOrcamento;

  Orcamento(
      {this.ativo,
      this.codigo,
      this.cliente,
      this.data,
      this.valorTotal,
      this.observacoes,
      this.produtosOrcamento});

  Orcamento.fromJson(Map<String, dynamic> json) {
    ativo = json['ativo'];
    codigo = json['codigo'];
    cliente =
        json['cliente'] != null ? new Cliente.fromJson(json['cliente']) : null;
    data = json['data'];
    valorTotal = json['valorTotal'];
    observacoes = json['observacoes'];
    if (json['produtosOrcamento'] != null) {
      produtosOrcamento = <ProdutosOrcamento>[];
      json['produtosOrcamento'].forEach((v) {
        produtosOrcamento.add(new ProdutosOrcamento.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ativo'] = this.ativo;
    data['codigo'] = this.codigo;
    if (this.cliente != null) {
      data['cliente'] = this.cliente.toJson();
    }
    data['data'] = this.data;
    data['valorTotal'] = this.valorTotal;
    data['observacoes'] = this.observacoes;
    if (this.produtosOrcamento != null) {
      data['produtosOrcamento'] =
          this.produtosOrcamento.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
