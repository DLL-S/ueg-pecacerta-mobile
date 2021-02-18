import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/ui/alterarCategoria_pagina.dart';

class CategoriasTela extends StatefulWidget {
  @override
  _CategoriasTelaState createState() => _CategoriasTelaState();
}

class _CategoriasTelaState extends State<CategoriasTela> {
  CategoriaController categoriaController = new CategoriaController();
  List<Categoria> listaCategoria = List();
  Categoria novaCategoria = Categoria();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _campoNomeCategoria = TextEditingController();

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
                    if (_formKey.currentState.validate())
                      novaCategoria.nome = _campoNomeCategoria.text;
                    novaCategoria.ativo = true;
                    final result = await categoriaController
                        .incluirCategoria(novaCategoria);
                    final text = result.error;
                    print(text);
                    _formKey.currentState.reset();
                    buscaLista();
                  })
            ],
          );
        });
      },
    );
  }

  void buscaLista() async {
    await categoriaController.listaCategorias().then((map) {
      listaCategoria = map;
    });
    setState(() {
      this.listaCategoria = listaCategoria;
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
        title: Text("Categorias"),
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
                onTap: () {},
                child: Icon(
                  Icons.search,
                ),
              )),
        ],
      ),
      body: ListView.builder(
          itemCount: listaCategoria.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(
                  listaCategoria[index].nome,
                ),
                subtitle:
                    Text(textoAtivo(listaCategoria[index].ativo.toString())),
                leading: Text(
                  listaCategoria[index].codigo.toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AlteraCategoriaTela()));
                },
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInformationDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
