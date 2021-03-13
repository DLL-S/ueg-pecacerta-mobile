import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';
import 'package:peca_certa_app/controller/produtoController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/models/Marca.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:peca_certa_app/controller/marcaController.dart';

class AlteraProdutoTela extends StatefulWidget {
  AlteraProdutoTela({this.produto});
  final Produto produto;
  @override
  _AlteraProdutoTelaState createState() => _AlteraProdutoTelaState();
}

class _AlteraProdutoTelaState extends State<AlteraProdutoTela> {
  APIResponse<List<Produto>> _apiResponse = APIResponse<List<Produto>>();

  APIResponse<List<Categoria>> _apiResponseCategoria =
      APIResponse<List<Categoria>>();
  APIResponse<List<Marca>> _apiResponseMarca = APIResponse<List<Marca>>();
  APIResponse<Categoria> _apiResponseCategoriaID = APIResponse<Categoria>();
  APIResponse<Marca> _apiResponseMarcaID = APIResponse<Marca>();

  ProdutoController produtoController = new ProdutoController();
  CategoriaController categoriaController = new CategoriaController();
  MarcaController marcaController = new MarcaController();

  bool _estaCarregando = false;

  void listaProdutos() async {
    setState(() {
      _estaCarregando = true;
    });
    _apiResponse = await produtoController.listarProdutos();
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

  @override
  void initState() {
    listaProdutos();
    listaCategorias();
    listaMarcas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String idCategoria;
    String idMarca;

    TextEditingController _controllerCampoCodigo =
        TextEditingController(text: widget.produto.codigo.toString());
    TextEditingController _controllerCampoCodigoDeBarras =
        TextEditingController(text: widget.produto.codigoDeBarras);
    TextEditingController _controllerCampoNome =
        TextEditingController(text: widget.produto.nome);
    TextEditingController _controllerCampoDescricao =
        TextEditingController(text: widget.produto.descricao);
    String _controllerDropDownCategoria =
        widget.produto.categoria.codigo.toString();
    String _controllerDropDownMarca = widget.produto.marca.codigo.toString();

    TextEditingController _controllerCampoPreco =
        TextEditingController(text: widget.produto.preco.toStringAsFixed(2));
    TextEditingController _controllerCampoQtdeEstoque =
        TextEditingController(text: widget.produto.qtdeEstoque.toString());
    bool _checkBoxController = widget.produto.ativo;

    Produto produtoAlterado = new Produto();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto.nome),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoCodigo,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Código",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoCodigoDeBarras,
                decoration: InputDecoration(
                  labelText: "Código de Barras",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoNome,
                decoration: InputDecoration(
                  labelText: "Nome",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoDescricao,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.topLeft,
                child: Text("Categoria",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _controllerDropDownCategoria,
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
                    setState(() async {
                      _controllerDropDownCategoria = value;
                      print(_controllerDropDownCategoria);

                      produtoAlterado.ativo = _checkBoxController;
                      produtoAlterado.codigo =
                          int.tryParse(_controllerCampoCodigo.text);
                      produtoAlterado.codigoDeBarras =
                          _controllerCampoCodigoDeBarras.text;
                      produtoAlterado.nome = _controllerCampoNome.text;
                      produtoAlterado.descricao =
                          _controllerCampoDescricao.text;
                      _apiResponseCategoriaID = await categoriaController
                          .consultaCategoriaID(idCategoria);
                      produtoAlterado.categoria = _apiResponseCategoriaID.data;
                      _apiResponseMarcaID =
                          await marcaController.consultaMarcaID(idMarca);
                      produtoAlterado.marca = _apiResponseMarcaID.data;
                      produtoAlterado.preco =
                          double.tryParse(_controllerCampoPreco.text);
                      produtoAlterado.qtdeEstoque =
                          int.tryParse(_controllerCampoQtdeEstoque.text);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                alignment: Alignment.topLeft,
                child: Text("Marcas",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _controllerDropDownMarca,
                  items: _apiResponseMarca.data
                          ?.map(
                            (Marca item) => new DropdownMenuItem(
                              child: new Text(
                                item.nome,
                                overflow: TextOverflow.ellipsis,
                              ),
                              value: item.codigo.toString(),
                            ),
                          )
                          ?.toList() ??
                      [],
                  onChanged: (newValue) {
                    setState(() async {
                      _controllerDropDownMarca = newValue;

                      produtoAlterado.ativo = _checkBoxController;
                      produtoAlterado.codigo =
                          int.tryParse(_controllerCampoCodigo.text);
                      produtoAlterado.codigoDeBarras =
                          _controllerCampoCodigoDeBarras.text;
                      produtoAlterado.nome = _controllerCampoNome.text;
                      produtoAlterado.descricao =
                          _controllerCampoDescricao.text;
                      _apiResponseCategoriaID = await categoriaController
                          .consultaCategoriaID(idCategoria);
                      produtoAlterado.categoria = _apiResponseCategoriaID.data;
                      _apiResponseMarcaID =
                          await marcaController.consultaMarcaID(idMarca);
                      produtoAlterado.marca = _apiResponseMarcaID.data;
                      produtoAlterado.preco =
                          double.tryParse(_controllerCampoPreco.text);
                      produtoAlterado.qtdeEstoque =
                          int.tryParse(_controllerCampoQtdeEstoque.text);
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoPreco,
                decoration: InputDecoration(
                  labelText: "Preço",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: _controllerCampoQtdeEstoque,
                decoration: InputDecoration(
                  labelText: "Quantidade",
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Ativo:",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Checkbox(
                      value: _checkBoxController,
                      onChanged: (_checkBoxController) {
                        setState(() {
                          widget.produto.ativo = _checkBoxController;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.redAccent[700],
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: TextButton(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                    child: TextButton(
                      child: Text(
                        "Alterar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        produtoAlterado.ativo = _checkBoxController;
                        produtoAlterado.codigo =
                            int.tryParse(_controllerCampoCodigo.text);
                        produtoAlterado.codigoDeBarras =
                            _controllerCampoCodigoDeBarras.text;
                        produtoAlterado.nome = _controllerCampoNome.text;
                        produtoAlterado.descricao =
                            _controllerCampoDescricao.text;
                        _apiResponseCategoriaID = await categoriaController
                            .consultaCategoriaID(idCategoria);
                        produtoAlterado.categoria =
                            _apiResponseCategoriaID.data;
                        _apiResponseMarcaID =
                            await marcaController.consultaMarcaID(idMarca);
                        produtoAlterado.marca = _apiResponseMarcaID.data;
                        produtoAlterado.preco =
                            double.tryParse(_controllerCampoPreco.text);
                        produtoAlterado.qtdeEstoque =
                            int.tryParse(_controllerCampoQtdeEstoque.text);

                        await produtoController.alterarProduto(produtoAlterado);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
