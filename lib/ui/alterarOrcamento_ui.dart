import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:peca_certa_app/controller/orcamentoController.dart';
import 'package:peca_certa_app/controller/produtoController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Cliente.dart';
import 'package:peca_certa_app/models/Orcamento.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:peca_certa_app/models/ProdutosOrcamento.dart';
import 'package:intl/intl.dart';
import 'package:peca_certa_app/ui/orcamentos_ui.dart';

class AlterarOrcamentoTela extends StatefulWidget {
  @override
  _AlterarOrcamentoTelaState createState() => _AlterarOrcamentoTelaState();
  AlterarOrcamentoTela({this.cliente, this.orcamentoCriado});
  final Cliente cliente;
  final Orcamento orcamentoCriado;
}

class _AlterarOrcamentoTelaState extends State<AlterarOrcamentoTela>
    with TickerProviderStateMixin {
//Controllers
  ProdutoController produtoController = new ProdutoController();
  OrcamentoController orcamentoController = new OrcamentoController();

  TabController _tabController;
  int _controllerCampoQtdeProd;
  double _controllerSpin = 0, valorTotaltxt;

  //API's
  APIResponse<List<Produto>> _apiResponse = APIResponse<List<Produto>>();

  //Variáveis
  List<ProdutosOrcamento> produtos = <ProdutosOrcamento>[];
  List<Produto> listaProdutosIncluidos = <Produto>[];
  APIResponse<Produto> nomeParaListaProdutosIncluidos = APIResponse<Produto>();
  Route routePageOrcamento =
      MaterialPageRoute(builder: (context) => OrcamentosTela());

  String _textProduto;

  //Lista de Retorno dos Produtos
  List<Produto> _filteredProdutos = <Produto>[];
  bool _estaCarregando = false;
  bool typing = false;

  void atribuindoValores() async {
    for (int i = 0; i < produtos.length; i++) {
      nomeParaListaProdutosIncluidos = await produtoController
          .consultaProdutoID(produtos[i].codigoProduto.toString());
      listaProdutosIncluidos.add(nomeParaListaProdutosIncluidos.data);
    }
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

  @override
  void initState() {
    super.initState();
    produtos = widget.orcamentoCriado.produtosOrcamento;
    atribuindoValores();
    listaProdutos();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  //Dialog

  @override
  Widget build(BuildContext context) {
    TextEditingController _textObservacoes =
        new TextEditingController(text: widget.orcamentoCriado.observacoes);

    AlertDialog alert = AlertDialog(
      title: Text("Confirmação"),
      content: Text(
          "Se sair, você perderá todas as alterações feitas no orçamento. Deseja realmente sair?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () async {
              Navigator.popAndPushNamed(context, '/inicial');
            },
            child: Text("Confirmar"))
      ],
    );

    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Detalhes do Orçamento"),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      });
                },
              ),
              actions: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () async {
                    Orcamento novoOrcamento = new Orcamento();

                    novoOrcamento.ativo = true;
                    novoOrcamento.codigo = widget.orcamentoCriado.codigo;
                    novoOrcamento.cliente = widget.cliente;
                    novoOrcamento.data =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());

                    novoOrcamento.observacoes = _textObservacoes.text;
                    novoOrcamento.produtosOrcamento = produtos;
                    double total = 0.0;
                    for (int i = 0; i < produtos.length; i++) {
                      total += listaProdutosIncluidos[i].preco *
                          produtos[i].quantidade;
                    }
                    novoOrcamento.valorTotal = total;

                    await orcamentoController.alterarOrcamento(novoOrcamento);
                    produtos.clear();
                    Navigator.popAndPushNamed(context, '/inicial');
                    Navigator.push(context, routePageOrcamento);
                  },
                )
              ],
            ),
            bottomNavigationBar: BottomAppBar(
                color: Theme.of(context).primaryColor,
                shape: CircularNotchedRectangle(),
                child: Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Valor Total: ",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        valorTotaltxt == null
                            ? "R\$ 0.00"
                            : "R\$" + valorTotaltxt.toString(),
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
            body: DefaultTabController(
                length: 3,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).primaryColor,
                      child: TabBar(labelColor: Colors.white, tabs: <Widget>[
                        Tab(
                          child: Text(
                            "Cliente",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Produtos",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Observações",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ]),
                    ),
                    Expanded(
                        child: TabBarView(children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        color: Theme.of(context).backgroundColor,
                        child: Card(
                            child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Detalhes",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Divider(
                                color: Theme.of(context).primaryColor,
                                height: 5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.cliente.tipoCliente == "PESSOA_FISICA"
                                    ? "Nome:"
                                    : "Razão Social:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.cliente.nome),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.cliente.tipoCliente == "PESSOA_FISICA"
                                    ? "CPF:"
                                    : "CNPJ:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.cliente.tipoCliente == "PESSOA_FISICA"
                                  ? UtilBrasilFields.obterCpf(
                                      widget.cliente.cpfCnpj)
                                  : UtilBrasilFields.obterCnpj(
                                      widget.cliente.cpfCnpj)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "E-mail:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(widget.cliente.email),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Telefone:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(UtilBrasilFields.obterTelefone(
                                  widget.cliente.telefone)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Endereço:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Logradouro: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.logradouro),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Nº: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.numero),
                                  Text(
                                    " | ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Complemento: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.complemento),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Bairro: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.bairro),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Cidade: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.cidade),
                                  Text(
                                    " | ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Estado: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.estado),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "CEP: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cliente.endereco.cep),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ),
                      Container(
                        color: Theme.of(context).backgroundColor,
                        padding: EdgeInsets.all(5),
                        child: Card(
                            child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Produtos",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                width: 300,
                                child: DropdownButton<String>(
                                    value: _textProduto,
                                    hint: Text('Escolha um produto'),
                                    isExpanded: true,
                                    items: _apiResponse.data
                                            ?.map(
                                              (Produto item) =>
                                                  new DropdownMenuItem(
                                                child: new Text(
                                                  item.nome,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                value: item.codigo.toString(),
                                              ),
                                            )
                                            ?.toList() ??
                                        [],
                                    onChanged: (String value) async {
                                      nomeParaListaProdutosIncluidos =
                                          await produtoController
                                              .consultaProdutoID(value);
                                      _controllerSpin = 0;
                                      setState(() {
                                        _textProduto = value;
                                      });
                                    }),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Quantidade",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  height: 50,
                                  width: 300,
                                  child: SpinBox(
                                    min: 0,
                                    value: _controllerSpin,
                                    max: nomeParaListaProdutosIncluidos.data ==
                                            null
                                        ? 100
                                        : nomeParaListaProdutosIncluidos
                                            .data.qtdeEstoque
                                            .toDouble(),
                                    onChanged: (value) {
                                      _controllerCampoQtdeProd = value.toInt();
                                    },
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(7),
                                  ),
                                ),
                                child: TextButton(
                                  child: Text(
                                    "Adicionar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  onPressed: () async {
                                    ProdutosOrcamento addProduto =
                                        new ProdutosOrcamento();

                                    addProduto.codigoProduto =
                                        int.parse(_textProduto);
                                    addProduto.quantidade =
                                        _controllerCampoQtdeProd;

                                    produtos.add(addProduto);

                                    listaProdutosIncluidos.add(
                                        nomeParaListaProdutosIncluidos.data);

                                    setState(() {
                                      _controllerSpin = 1;
                                      _textProduto = null;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                "Produtos Adicionados",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      width: 200,
                                      child: Text(
                                        "Produto",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    Container(
                                      width: 100,
                                      child: Text(
                                        "Quantidade",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: SingleChildScrollView(
                                    child: Builder(builder: (_) {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: produtos.length,
                                        itemBuilder:
                                            (BuildContext _, int index) {
                                          return Dismissible(
                                              key: Key(DateTime.now()
                                                      .toString() +
                                                  produtos[index].toString()),
                                              background: Container(
                                                width: 300,
                                                color: Colors.red[900],
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                alignment:
                                                    Alignment.centerRight,
                                              ),
                                              child: Card(
                                                shadowColor: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 200,
                                                      child: Text(
                                                        listaProdutosIncluidos[
                                                                index]
                                                            .nome,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 100,
                                                      child: Text(
                                                        produtos[index]
                                                            .quantidade
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              direction:
                                                  DismissDirection.endToStart,
                                              onDismissed: (direction) {
                                                if (direction ==
                                                    DismissDirection
                                                        .endToStart) {
                                                  setState(() {
                                                    produtos.remove(
                                                        produtos[index]);
                                                    listaProdutosIncluidos.remove(
                                                        listaProdutosIncluidos[
                                                            index]);
                                                  });
                                                }
                                              });
                                        },
                                      );
                                    }),
                                  ))
                            ],
                          ),
                        )),
                      ),
                      Container(
                        color: Theme.of(context).backgroundColor,
                        padding: EdgeInsets.all(5),
                        child: Card(
                            child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Container(
                            width: 400,
                            child: TextField(
                              controller: _textObservacoes,
                              maxLines: null,
                              onEditingComplete: () {
                                _textObservacoes.text;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Observações'),
                            ),
                          ),
                        )),
                      ),
                    ]))
                  ],
                ))),
        onWillPop: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            }));
  }
}
