import 'package:flutter/material.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';

class ProdutosTela extends StatefulWidget {
  @override
  _ProdutosTelaState createState() => _ProdutosTelaState();
}

class _ProdutosTelaState extends State<ProdutosTela> {
  CategoriaController categoriaController = new CategoriaController();
  List<Categoria> cat;

  @override
  Widget build(BuildContext context) {
    categoriaController.listaCategorias().then((map) {
      cat = map;
      print(cat.length);
    });
    return Scaffold(
      backgroundColor: Colors.blueGrey,
    );
  }
}
