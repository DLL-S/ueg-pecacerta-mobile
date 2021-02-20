import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';
import 'package:peca_certa_app/controller/marcaController.dart';
import 'package:peca_certa_app/controller/produtoController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/models/Marca.dart';
import 'package:peca_certa_app/models/Produto.dart';

class ProdutosTela extends StatefulWidget {
  @override
  _ProdutosTelaState createState() => _ProdutosTelaState();
}

class _ProdutosTelaState extends State<ProdutosTela> {
  //Controllers
  ProdutoController produtoController = new ProdutoController();
  CategoriaController categoriaController = new CategoriaController();
  MarcaController marcaController = new MarcaController();

  //API's
  APIResponse<List<Produto>> _apiResponse = APIResponse<List<Produto>>();
  APIResponse<List<Categoria>> _apiResponseCategoria =
      APIResponse<List<Categoria>>();
  APIResponse<List<Marca>> _apiResponseMarca = APIResponse<List<Marca>>();
  APIResponse<Categoria> _apiResponseCategoriaID = APIResponse<Categoria>();
  APIResponse<Marca> _apiResponseMarcaID = APIResponse<Marca>();

  //Lista de Retorno dos Produtos
  List<Produto> _filteredProdutos = List<Produto>();

  //Variáveis
  Produto novoProduto = Produto();
  bool _estaCarregando = false;
  bool typing = false;

  //Chave de identificação do Form e controllers dos texts fields
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _campoBuscaProduto = TextEditingController();
  TextEditingController _campoNomeProduto = TextEditingController();
  TextEditingController _campoCodigoDeBarrasProduto = TextEditingController();
  TextEditingController _campoDescricaoProduto = TextEditingController();
  TextEditingController _campoPrecoProduto = TextEditingController();
  TextEditingController _campoQtdeEstoqueProduto = TextEditingController();
  String textCategoria, idCategoria;
  String textMarca, idMarca;

  //Controle checkbox
  bool _sel = true;

  //Limpa Campos Fora do form
  void limpaCampos() {
    textCategoria = null;
    textMarca = null;
    _sel = true;
  }

//Solicitações para API dos dados de produtos, categorias, marcas.
  void listaProdutos() async {
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

  void listaCategorias() async {
    _apiResponseCategoria = await categoriaController.listarCategorias();
    _apiResponseCategoria.data.sort((a, b) {
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });
  }

  void listaMarcas() async {
    _apiResponseMarca = await marcaController.listarMarcas();
    _apiResponseMarca.data.sort((a, b) {
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });
  }

//Mostra dialog de cadastro de um novo produto
  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: Container(
                height: 400,
                child: SingleChildScrollView(
                    child: Column(
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
                        return value.isNotEmpty ? null : "Campo Obrigatório";
                      },
                      maxLength: 13,
                      decoration: InputDecoration(hintText: "Codigo de barras"),
                    ),
                    TextFormField(
                      controller: _campoDescricaoProduto,
                      maxLength: 50,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(hintText: "Descrição"),
                    ),
                    DropdownButton<String>(
                        value: textCategoria,
                        hint: Text('Selecione a categoria'),
                        isExpanded: true,
                        items: _apiResponseCategoria.data
                                ?.map(
                                  (Categoria item) => new DropdownMenuItem(
                                    child: new Text(
                                      item.nome,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: item.codigo.toString(),
                                  ),
                                )
                                ?.toList() ??
                            [],
                        onChanged: (String value) {
                          setState(() {
                            textCategoria = value;
                            idCategoria = value;
                          });
                        }),
                    DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Selecione a marca'),
                        value: textMarca,
                        items: _apiResponseMarca.data
                                ?.map(
                                  (Marca item) => new DropdownMenuItem(
                                    child: new Text(
                                      '${item.nome}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    value: item.codigo.toString(),
                                  ),
                                )
                                ?.toList() ??
                            [],
                        onChanged: (String value) {
                          setState(() {
                            textMarca = value;
                            idMarca = value;
                          });
                        }),
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
                    /*Row(
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
                    )*/
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
                  limpaCampos();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Text('Adicionar'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      //Atribuindo os valores dos campos ao atributos de produto
                      novoProduto.codigoDeBarras =
                          _campoCodigoDeBarrasProduto.text;
                      novoProduto.nome = _campoNomeProduto.text;
                      novoProduto.descricao = _campoDescricaoProduto.text;
                      _apiResponseCategoriaID = await categoriaController
                          .consultaCategoriaID(idCategoria);
                      novoProduto.categoria = _apiResponseCategoriaID.data;
                      _apiResponseMarcaID =
                          await marcaController.consultaMarcaID(idMarca);
                      novoProduto.marca = _apiResponseMarcaID.data;
                      novoProduto.preco =
                          double.tryParse(_campoPrecoProduto.text);
                      novoProduto.qtdeEstoque =
                          int.tryParse(_campoQtdeEstoqueProduto.text);
                      novoProduto.ativo = _sel = true;

                      //
                      await produtoController.incluirProduto(novoProduto);
                      limpaCampos();
                      Navigator.of(context).pop();
                      _formKey.currentState.reset();
                      listaProdutos();
                    }
                  }),
            ],
          );
        });
      },
    );
  }

//Converte o Status do produto para string Ativo ou Inativo
  String textoAtivo(String text) {
    if (text == 'true') {
      return 'Ativo';
    } else {
      return 'Inativo';
    }
  }

  @override
  void initState() {
    listaProdutos();
    listaCategorias();
    listaMarcas();
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
                                      style: _filteredProdutos[index].ativo
                                          ? TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                              color: Color(0xFF008000))
                                          : TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 10,
                                              color: Color(0xFF8B0000)),
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
                                'R\$ ${_filteredProdutos[index].preco.toStringAsFixed(2)}',
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
