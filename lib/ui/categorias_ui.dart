import 'dart:async';

import 'package:ant_icons/ant_icons.dart';
import 'package:ant_icons/icon_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';
import 'package:peca_certa_app/models/API_Response.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/ui/alterarCategoria_ui.dart';

class CategoriasTela extends StatefulWidget {
  @override
  _CategoriasTelaState createState() => _CategoriasTelaState();
}

class _CategoriasTelaState extends State<CategoriasTela> {
  CategoriaController categoriaController = new CategoriaController();
  APIResponse<List<Categoria>> _apiResponse = APIResponse<List<Categoria>>();
  List<Categoria> _filteredCategorias = List<Categoria>();

  Categoria novaCategoria = Categoria();
  bool _estaCarregando = false;
  bool typing = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _campoNomeCategoria = TextEditingController();
  TextEditingController _campoBuscaCategoria = TextEditingController();

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
                    Text("Adicionar Categoria"),
                    TextFormField(
                      controller: _campoNomeCategoria,
                      validator: (value) {
                        return value.isNotEmpty ? null : "Campo Obrigatório.";
                      },
                      decoration: InputDecoration(
                          hintText: "Insira o nome da categoria"),
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
                      novaCategoria.nome = _campoNomeCategoria.text;
                      novaCategoria.ativo = true;
                      await categoriaController.incluirCategoria(novaCategoria);
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
    _apiResponse = await categoriaController.listarCategorias();
    _filteredCategorias = _apiResponse.data;
    _filteredCategorias.sort((a, b) {
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
                  controller: _campoBuscaCategoria,
                  style: TextStyle(color: Colors.white),
                  onChanged: (string) {
                    setState(() {
                      _filteredCategorias = _apiResponse.data
                          .where((i) => i.nome
                              .toLowerCase()
                              .contains(string.toLowerCase()))
                          .toList();
                    });
                  },
                )
              : Text("Categorias"),
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
                  itemCount: _filteredCategorias.length,
                  itemBuilder: (BuildContext _, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(
                          _filteredCategorias[index].nome,
                        ),
                        subtitle: Text(textoAtivo(
                            _filteredCategorias[index].ativo.toString())),
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
                                  builder: (context) => AlteraCategoriaTela()));
                        },
                      ),
                    );
                  });
            }))
          ],
        ));
  }
}
