class ProdutosOrcamento {
  int codigo;
  int codigoProduto;
  int codigoOrcamento;
  int quantidade;

  ProdutosOrcamento(
      {this.codigo, this.codigoProduto, this.codigoOrcamento, this.quantidade});

  ProdutosOrcamento.fromJson(Map<String, dynamic> json) {
    codigo = json['codigo'];
    codigoProduto = json['codigoProduto'];
    codigoOrcamento = json['codigoOrcamento'];
    quantidade = json['quantidade'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['codigo'] = this.codigo;
    data['codigoProduto'] = this.codigoProduto;
    data['codigoOrcamento'] = this.codigoOrcamento;
    data['quantidade'] = this.quantidade;
    return data;
  }
}
