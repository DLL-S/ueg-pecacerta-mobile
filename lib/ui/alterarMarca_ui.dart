import 'package:flutter/material.dart';
import 'package:peca_certa_app/models/Marca.dart';
import 'package:peca_certa_app/controller/marcaController.dart';

class AlteraMarcaTela extends StatefulWidget {
  AlteraMarcaTela({this.idMarca});
  final Marca idMarca;
  @override
  _AlteraMarcaTelaState createState() => _AlteraMarcaTelaState();
}

class _AlteraMarcaTelaState extends State<AlteraMarcaTela> {
  @override
  Widget build(BuildContext context) {
    MarcaController categoriaController = new MarcaController();

    TextEditingController _controllerCampoCodigo =
        TextEditingController(text: widget.idMarca.codigo.toString());
    TextEditingController _controllerCampoNome =
        TextEditingController(text: widget.idMarca.nome);
    bool _checkBoxController = widget.idMarca.ativo;

    Marca marcaAlterada = new Marca();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.idMarca.nome),
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
                        widget.idMarca.codigo =
                            int.tryParse(_controllerCampoCodigo.text);
                        widget.idMarca.nome = _controllerCampoNome.text;
                        widget.idMarca.ativo = _checkBoxController;
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
                      marcaAlterada.ativo = _checkBoxController;
                      marcaAlterada.codigo =
                          int.tryParse(_controllerCampoCodigo.text);
                      marcaAlterada.nome = _controllerCampoNome.text;
                      await categoriaController.alterarMarca(marcaAlterada);
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
