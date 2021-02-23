import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/marcaController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Marca.dart';
import 'package:peca_certa_app/ui/alterarMarca_ui.dart';

class MarcasTela extends StatefulWidget {
  @override
  _MarcasTelaState createState() => _MarcasTelaState();
}

class _MarcasTelaState extends State<MarcasTela> {
  MarcaController marcaController = new MarcaController();
  APIResponse<List<Marca>> _apiResponse = APIResponse<List<Marca>>();
  List<Marca> _filteredMarcas = List<Marca>();

  Marca novaMarca = Marca();
  bool _estaCarregando = false;
  bool typing = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _campoNomeMarca = TextEditingController();
  TextEditingController _campoBuscaMarca = TextEditingController();

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Adicionar Marca"),
                    TextFormField(
                      controller: _campoNomeMarca,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration:
                          InputDecoration(hintText: "Insira o nome da marca"),
                    ),
                  ],
                )),
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
                      novaMarca.nome = _campoNomeMarca.text;
                      novaMarca.ativo = true;
                      await marcaController.incluirMarca(novaMarca);
                      Navigator.of(context).pop();
                      _formKey.currentState.reset();
                      buscaLista();
                    }
                  })
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
    _apiResponse = await marcaController.listarMarcas();
    _filteredMarcas = _apiResponse.data;
    _filteredMarcas.sort((a, b) {
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
                  controller: _campoBuscaMarca,
                  style: TextStyle(color: Colors.white),
                  onChanged: (string) {
                    setState(() {
                      _filteredMarcas = _apiResponse.data
                          .where((i) => i.nome
                              .toLowerCase()
                              .contains(string.toLowerCase()))
                          .toList();
                    });
                  },
                )
              : Text("Marcas"),
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
                    itemCount: _filteredMarcas.length,
                    itemBuilder: (BuildContext _, int index) {
                      return Card(
                        child: ListTile(
                          title: Text(
                            _filteredMarcas[index].nome,
                          ),
                          subtitle: Text(textoAtivo(
                              _filteredMarcas[index].ativo.toString())),
                          /*leading: Text(
                          _apiResponse.data[index].codigo.toString(),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),*/
                          trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AlteraMarcaTela(
                                        idMarca: _filteredMarcas[index])));
                          },
                        ),
                      );
                    });
              }))
            ],
          ),
          onRefresh: () async {
            buscaLista();
          },
        ));
  }
}
