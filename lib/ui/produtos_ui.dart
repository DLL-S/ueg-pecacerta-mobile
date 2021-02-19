import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peca_certa_app/controller/produtoController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Produto.dart';

class ProdutosTela extends StatefulWidget {
  @override
  _ProdutosTelaState createState() => _ProdutosTelaState();
}

class _ProdutosTelaState extends State<ProdutosTela> {
  ProdutoController produtoController = new ProdutoController();
  APIResponse<List<Produto>> _apiResponse = APIResponse<List<Produto>>();
  List<Produto> _filteredProdutos = List<Produto>();

  Produto novoProduto = Produto();
  bool _estaCarregando = false;
  bool typing = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _campoBuscaProduto = TextEditingController();
  TextEditingController _campoNomeProduto = TextEditingController();
  TextEditingController _campoCodigoDeBarrasProduto = TextEditingController();
  TextEditingController _campoDescricaoProduto = TextEditingController();
  TextEditingController _campoPrecoProduto = TextEditingController();
  TextEditingController _campoQtdeEstoqueProduto = TextEditingController();
  bool _sel = false;

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Container(
                height: 300,
                width: 300,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Adicionar Produto"),
                    TextFormField(
                      controller: _campoNomeProduto,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(hintText: "Nome do produto"),
                    ),
                    TextFormField(
                      controller: _campoCodigoDeBarrasProduto,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      maxLength: 13,
                      decoration: InputDecoration(hintText: "Codigo de barras"),
                    ),
                    TextFormField(
                      controller: _campoDescricaoProduto,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(hintText: "Descrição"),
                    ),
                    TextFormField(
                      controller: _campoPrecoProduto,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(hintText: "Preço"),
                    ),
                    TextFormField(
                      controller: _campoQtdeEstoqueProduto,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(hintText: "Quantidade"),
                    ),
                    Row(
                      children: <Widget>[
                        Text("Ativo:"),
                        Checkbox(
                            value: _sel,
                            onChanged: (bool isMarked) {
                              setState(() {
                                _sel = isMarked;
                              });
                            })
                      ],
                    )
                  ],
                )),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  _formKey.currentState.reset();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Adicionar'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      novoProduto.nome = _campoNomeProduto.text;
                      novoProduto.ativo = true;
                      await produtoController.incluirProduto(novoProduto);
                      Navigator.of(context).pop();
                      _formKey.currentState.reset();
                      buscaLista();
                    }
                  }),
            ],
          );
        });
      },
    );
  }

  void buscaLista() async {
    setState(() {
      _estaCarregando = true;
    });
    _apiResponse = await produtoController.listarProdutos();
    _filteredProdutos = _apiResponse.data;
    _filteredProdutos.sort((a, b) {
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });
    setState(() {
      _estaCarregando = false;
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
    buscaLista();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: typing
              ? TextFormField(
                  controller: _campoBuscaProduto,
                  style: TextStyle(color: Colors.white),
                  onChanged: (string) {
                    setState(() {
                      _filteredProdutos = _apiResponse.data
                          .where((i) => i.nome
                              .toLowerCase()
                              .contains(string.toLowerCase()))
                          .toList();
                    });
                  },
                )
              : Text("Produtos"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      typing = !typing;
                    });
                  },
                  child: Icon(
                    typing ? Icons.send : Icons.search,
                  ),
                )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showInformationDialog(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Column(
          children: <Widget>[
            Expanded(child: Builder(builder: (_) {
              if (_estaCarregando) {
                return Center(child: CircularProgressIndicator());
              }
              if (_apiResponse.error) {
                return Center(
                    child: Text(_apiResponse.errorMessage.toString()));
              }
              return ListView.builder(
                  itemCount: _filteredProdutos.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Card(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding:
                                EdgeInsets.only(top: 10, bottom: 10, left: 10),
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                /*Row(
                                  children: [
                                    Text(
                                      "Código: ${_apiResponse.data[index].codigo}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),*/
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      _filteredProdutos[index].nome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      _filteredProdutos[index].descricao,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Marca: ${_filteredProdutos[index].marca.nome}  |  Categoria: ${_apiResponse.data[index].categoria.nome}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Qtde. Estoque:  ${_filteredProdutos[index].qtdeEstoque}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      'Status:  ${textoAtivo(_filteredProdutos[index].ativo.toString())}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          padding:
                              EdgeInsets.only(top: 10, bottom: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                'R\$${_filteredProdutos[index].preco.toStringAsFixed(2)}',
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ));
                  });
            }))
          ],
        ));
  }
}
