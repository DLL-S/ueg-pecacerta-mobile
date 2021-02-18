import 'package:flutter/material.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:peca_certa_app/controller/produtoController.dart';

class ProdutosTela extends StatefulWidget {
  @override
  _ProdutosTelaState createState() => _ProdutosTelaState();
}

class _ProdutosTelaState extends State<ProdutosTela> {
  ProdutoController produtoController = new ProdutoController();
  List<Produto> listaProdutos = List();

  void buscaLista() async {
    await produtoController.listaProdutos().then((map) {
      listaProdutos = map;
    });
    setState(() {
      this.listaProdutos = listaProdutos;
    });
  }

  String textoAtivo(String text) {
    if (text == 'true') {
      return 'Ativo';
    } else {
      return 'Inativo';
    }
  }

  @override
  void initState() {
    super.initState();
    buscaLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: () async {},
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
          itemCount: listaProdutos.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.only(top: 10, right: 5),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Código: ${listaProdutos[index].codigo}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listaProdutos[index].nome,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black),
                          ),
                          Text(
                            listaProdutos[index].descricao,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: Colors.black),
                          ),
                          Text(
                            'Marca: ${listaProdutos[index].marca.nome}  |  Categoria: ${listaProdutos[index].categoria.nome}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: Colors.black),
                          ),
                          Text(
                            'Qtde. Estoque:  ${listaProdutos[index].qtdeEstoque}',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: Colors.black),
                          ),
                          Text(
                            'R\$ ${listaProdutos[index].preco.toStringAsFixed(2)}',
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          ButtonBar(
                            children: [
                              FlatButton(
                                  onPressed: () {}, child: Text("Detalhes"))
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
