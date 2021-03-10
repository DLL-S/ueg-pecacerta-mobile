import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/funcionarioController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Funcionario.dart';
import 'package:intl/intl.dart';
import 'package:cpfcnpj/cpfcnpj.dart';

class FuncionarioTela extends StatefulWidget {
  @override
  _FuncionarioTelaState createState() => _FuncionarioTelaState();
}

class _FuncionarioTelaState extends State<FuncionarioTela> {
  //Formatar Data
  DateFormat dateFormat = new DateFormat('dd-MM-yyyy');

  //Controller
  FuncionarioController funcionarioController = new FuncionarioController();

  //API
  APIResponse<List<Funcionario>> _apiResponse =
      APIResponse<List<Funcionario>>();

  //Controle dos TextField
  TextEditingController _campoBuscaFuncionario = TextEditingController();

  List<Funcionario> _filteredFuncionarios = List<Funcionario>();

  //Refresh Indicator
  bool _estaCarregando = false;

  //Solicitações para API dos dados de funcionários.
  void listaFuncionarios() async {
    setState(() {
      _estaCarregando = true;
    });
    _apiResponse = await funcionarioController.listarFuncionariosAtivos();
    _filteredFuncionarios = _apiResponse.data;
    _filteredFuncionarios.sort((a, b) {
      return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
    });
    setState(() {
      _estaCarregando = false;
    });
  }

  bool typing = false;

  @override
  void initState() {
    listaFuncionarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: typing
            ? TextFormField(
                controller: _campoBuscaFuncionario,
                style: TextStyle(color: Colors.white),
                onChanged: (string) {
                  setState(() {
                    _filteredFuncionarios = _apiResponse.data
                        .where((i) =>
                            i.nome.toLowerCase().contains(string.toLowerCase()))
                        .toList();
                  });
                },
              )
            : Text("Funcionários"),
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
        onPressed: () {},
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
                  itemCount: _filteredFuncionarios.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Card(
                        child: ExpansionTile(
                      backgroundColor: Theme.of(context).backgroundColor,
                      childrenPadding:
                          EdgeInsets.only(left: 10, bottom: 10, right: 10),
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      title: Text(_filteredFuncionarios[index].nome),
                      subtitle: Text(
                        _filteredFuncionarios[index].tipoDeFuncionario,
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
                              "CPF: " +
                                  CPF.format(_filteredFuncionarios[index].cpf),
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
                              "Data de Nascimento: " +
                                  _filteredFuncionarios[index]
                                      .dataNasc
                                      .substring(5, 7) +
                                  "/" +
                                  _filteredFuncionarios[index]
                                      .dataNasc
                                      .substring(8, 10) +
                                  "/" +
                                  _filteredFuncionarios[index]
                                      .dataNasc
                                      .substring(0, 4),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "E-mail: " + _filteredFuncionarios[index].email,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Telefone: " +
                                  _filteredFuncionarios[index].telefone,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Endereço: " +
                                  _filteredFuncionarios[index]
                                      .endereco
                                      .logradouro,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              "Nº: " +
                                  _filteredFuncionarios[index].endereco.numero +
                                  " | Complemento: " +
                                  _filteredFuncionarios[index]
                                      .endereco
                                      .complemento,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            Text(
                              "Bairro: " +
                                  _filteredFuncionarios[index].endereco.bairro,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Cidade: " +
                                  _filteredFuncionarios[index].endereco.cidade +
                                  " | Estado: " +
                                  _filteredFuncionarios[index].endereco.estado,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "CEP: " +
                                  _filteredFuncionarios[index].endereco.cep,
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
            listaFuncionarios();
          }),
    );
  }
}
