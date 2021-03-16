import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/orcamentoController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Orcamento.dart';
import 'package:peca_certa_app/ui/alterarOrcamento_ui.dart';

class OrcamentosTela extends StatefulWidget {
  @override
  _OrcamentosTelaState createState() => _OrcamentosTelaState();
  OrcamentosTela({this.orcamento});
  final Orcamento orcamento;
}

class _OrcamentosTelaState extends State<OrcamentosTela> {
  OrcamentoController orcamentoController = new OrcamentoController();
  APIResponse<List<Orcamento>> _apiResponse =
      new APIResponse<List<Orcamento>>();
  List<Orcamento> _filteredOrcamentos = <Orcamento>[];

  bool typing = false;
  TextEditingController _campoNomeClienteOrcamento = TextEditingController();

  //Refresh Indicator
  bool _estaCarregando = false;

  //Solicitações para API dos dados de funcionários.
  void listarOrcamentos() async {
    setState(() {
      _estaCarregando = true;
    });
    _apiResponse = await orcamentoController.listarOrcamentos();
    _filteredOrcamentos = _apiResponse.data;
    _filteredOrcamentos.sort((a, b) {
      return a.codigo
          .toString()
          .toLowerCase()
          .compareTo(b.codigo.toString().toLowerCase());
    });
    setState(() {
      _estaCarregando = false;
    });
  }

  @override
  void initState() {
    listarOrcamentos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: typing
            ? TextFormField(
                controller: _campoNomeClienteOrcamento,
                style: TextStyle(color: Colors.white),
                onChanged: (string) {
                  setState(() {
                    _filteredOrcamentos = _apiResponse.data
                        .where((i) =>
                            i.cliente.nome
                                .toLowerCase()
                                .contains(string.toLowerCase()) ||
                            i.codigo.toString().startsWith(string))
                        .toList();
                  });
                },
              )
            : Text("Orçamentos"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
          child: Column(
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
                  itemCount: _filteredOrcamentos.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Dismissible(
                        key: Key(_filteredOrcamentos[index].toString()),
                        child: Card(
                          child: ExpansionTile(
                            backgroundColor: Theme.of(context).backgroundColor,
                            childrenPadding: EdgeInsets.only(
                                left: 10, bottom: 10, right: 10),
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            title: Text("Orçamento nº: " +
                                _filteredOrcamentos[index].codigo.toString()),
                            subtitle: Text(
                              "Data: " +
                                  _filteredOrcamentos[index]
                                      .data
                                      .substring(8, 10) +
                                  "/" +
                                  _filteredOrcamentos[index]
                                      .data
                                      .substring(5, 7) +
                                  "/" +
                                  _filteredOrcamentos[index]
                                      .data
                                      .substring(0, 4),
                              style: TextStyle(fontSize: 12),
                            ),
                            leading: Icon(
                              Icons.attach_money_outlined,
                              color: Colors.black,
                            ),
                            children: <Widget>[
                              Divider(
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Cliente: " +
                                        _filteredOrcamentos[index].cliente.nome,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Valor Toal: R\$ " +
                                        _filteredOrcamentos[index]
                                            .valorTotal
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Observações: " +
                                        _filteredOrcamentos[index].observacoes,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        background: Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlterarOrcamentoTela(
                                          cliente: _filteredOrcamentos[index]
                                              .cliente,
                                          orcamentoCriado:
                                              _filteredOrcamentos[index],
                                        )));
                            listarOrcamentos();
                          }
                          listarOrcamentos();
                        });
                  },
                );
              })),
            ],
          ),
          onRefresh: () async {
            listarOrcamentos();
          }),
    );
  }
}
