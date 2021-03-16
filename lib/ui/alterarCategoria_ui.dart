import 'package:flutter/material.dart';
import 'package:peca_certa_app/models/Categoria.dart';
import 'package:peca_certa_app/controller/categoriaController.dart';

class AlteraCategoriaTela extends StatefulWidget {
  AlteraCategoriaTela({this.idCategoria});
  final Categoria idCategoria;

  @override
  _AlteraCategoriaTelaState createState() => _AlteraCategoriaTelaState();
}

class _AlteraCategoriaTelaState extends State<AlteraCategoriaTela> {
  CategoriaController categoriaController = new CategoriaController();

  @override
  Widget build(BuildContext context) {
    TextEditingController _controllerCampoCodigo =
        TextEditingController(text: widget.idCategoria.codigo.toString());
    TextEditingController _controllerCampoNome =
        TextEditingController(text: widget.idCategoria.nome);
    bool _checkBoxController = widget.idCategoria.ativo;

    Categoria categoriaAlterada = new Categoria();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.idCategoria.nome),
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
                        widget.idCategoria.codigo =
                            int.tryParse(_controllerCampoCodigo.text);
                        widget.idCategoria.nome = _controllerCampoNome.text;
                        widget.idCategoria.ativo = _checkBoxController;
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
                      categoriaAlterada.ativo = _checkBoxController;
                      categoriaAlterada.codigo =
                          int.tryParse(_controllerCampoCodigo.text);
                      categoriaAlterada.nome = _controllerCampoNome.text;
                      await categoriaController
                          .alterarCategoria(categoriaAlterada);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
