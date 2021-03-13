import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/clienteController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Cliente.dart';
import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:peca_certa_app/ui/adicionar_cliente_ui.dart';

class ClienteTela extends StatefulWidget {
  @override
  _ClienteTelaState createState() => _ClienteTelaState();
}

class _ClienteTelaState extends State<ClienteTela> {
  TextEditingController _campoBuscaCliente = TextEditingController();

  //Controller
  ClienteController clienteController = new ClienteController();

  //API
  APIResponse<List<Cliente>> _apiResponse = APIResponse<List<Cliente>>();

  //Controle dos TextField

  List<Cliente> _filteredClientes = <Cliente>[];

  //Refresh Indicator
  bool _estaCarregando = false;

  //Solicitações para API dos dados de funcionários.
  void listaClientes() async {
    setState(() {
      _estaCarregando = true;
    });
    _apiResponse = await clienteController.listarClientes();
    _filteredClientes = _apiResponse.data;
    _filteredClientes.sort((a, b) {
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });
    setState(() {
      _estaCarregando = false;
    });
  }

  bool typing = false;

  @override
  void initState() {
    listaClientes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: typing
            ? TextFormField(
                controller: _campoBuscaCliente,
                style: TextStyle(color: Colors.white),
                onChanged: (string) {
                  setState(() {
                    _filteredClientes = _apiResponse.data
                        .where((i) =>
                            i.nome.toLowerCase().contains(string.toLowerCase()))
                        .toList();
                  });
                },
              )
            : Text("Clientes"),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdicionarClienteTela()));
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
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
                  itemCount: _filteredClientes.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Card(
                        child: ExpansionTile(
                      backgroundColor: Theme.of(context).backgroundColor,
                      childrenPadding:
                          EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      title: Text(_filteredClientes[index].nome),
                      subtitle: Text(
                        _filteredClientes[index].tipoCliente ==
                                "PESSOA_JURIDICA"
                            ? "Empresa"
                            : "Pessoa",
                        style: TextStyle(fontSize: 12),
                      ),
                      leading: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/person.png"),
                              scale: 0.5),
                        ),
                      ),
                      children: <Widget>[
                        Divider(
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              _filteredClientes[index].tipoCliente ==
                                      "PESSOA_JURIDICA"
                                  ? "CNPJ: " +
                                      CNPJ.format(
                                          _filteredClientes[index].cpfCnpj)
                                  : "CPF: " +
                                      CPF.format(
                                          _filteredClientes[index].cpfCnpj),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _filteredClientes[index].tipoCliente ==
                                      "PESSOA_JURIDICA"
                                  ? "Data de Fundação: " +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(8, 10) +
                                      "/" +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(5, 7) +
                                      "/" +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(0, 4)
                                  : "Data de Nascimento: " +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(8, 10) +
                                      "/" +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(5, 7) +
                                      "/" +
                                      _filteredClientes[index]
                                          .dataNascFund
                                          .substring(0, 4),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "E-mail: " + _filteredClientes[index].email,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Telefone: " + _filteredClientes[index].telefone,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Endereço: " +
                                  _filteredClientes[index].endereco.logradouro,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              "Nº: " +
                                  _filteredClientes[index].endereco.numero +
                                  " | Complemento: " +
                                  _filteredClientes[index].endereco.complemento,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              "Bairro: " +
                                  _filteredClientes[index].endereco.bairro,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Cidade: " +
                                  _filteredClientes[index].endereco.cidade +
                                  " | Estado: " +
                                  _filteredClientes[index].endereco.estado,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "CEP: " + _filteredClientes[index].endereco.cep,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ));
                  },
                );
              })),
            ],
          ),
          onRefresh: () async {
            listaClientes();
          }),
    );
  }
}
