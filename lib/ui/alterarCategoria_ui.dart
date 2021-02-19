import 'package:flutter/material.dart';

class AlteraCategoriaTela extends StatefulWidget {
  @override
  _AlteraCategoriaTelaState createState() => _AlteraCategoriaTelaState();
}

class _AlteraCategoriaTelaState extends State<AlteraCategoriaTela> {
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
      ),
    );
  }
}
