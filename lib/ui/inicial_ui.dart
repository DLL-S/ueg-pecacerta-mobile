import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peca_certa_app/ui/categorias_ui.dart';
import 'package:peca_certa_app/ui/clientes_ui.dart';
import 'package:peca_certa_app/ui/funcionarios_ui.dart';
import 'package:peca_certa_app/ui/login_ui.dart';
import 'package:peca_certa_app/ui/marcas_ui.dart';
import 'package:peca_certa_app/ui/produtos_ui.dart';
import 'package:peca_certa_app/ui/sobre_ui.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  AlertDialog showAlertDialog(BuildContext context) {
    AlertDialog alerta = AlertDialog(
      title: Text("Sair"),
      content: Text("Você deseja realmente sair?"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar")),
        TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPagina()));
            },
            child: Text(
              "Sair",
              style: TextStyle(color: Colors.red),
            ))
      ],
    );
    return alerta;
  }

  Future<bool> _showExitDialog() {
    return showDialog(
        context: context,
        builder: (item) => AlertDialog(
              title: Text("Sair"),
              content: Text("Você deseja realmente sair?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancelar")),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginPagina()));
                    },
                    child: Text(
                      "Sair",
                      style: TextStyle(color: Colors.red),
                    ))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Página Inicial"),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.notifications,
              ),
            ),
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return {'Sobre', 'Sair'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              onSelected: (value) {
                if (value == 'Sair') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return showAlertDialog(context);
                    },
                  );
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SobreTela()));
                }
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xFFC3CFD9),
                      width: 1,
                    ),
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/logo.png")),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                leading: Icon(AntIcons.inbox),
                title: Text(
                  'Produtos',
                  style: TextStyle(color: Color(0xFF293845), fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProdutosTela()));
                },
              ),
              ListTile(
                leading: Icon(AntIcons.shop_outline),
                title: Text(
                  'Estoque',
                  style: TextStyle(color: Color(0xFF293845), fontSize: 20),
                ),
              ),
              ListTile(
                leading: Icon(AntIcons.idcard_outline),
                title: Text(
                  'Funcionários',
                  style: TextStyle(color: Color(0xFF293845), fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FuncionarioTela()));
                },
              ),
              ListTile(
                leading: Icon(AntIcons.file_done),
                title: Text(
                  'Marcas',
                  style: TextStyle(color: Color(0xFF293845), fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MarcasTela()));
                },
              ),
              ListTile(
                leading: Icon(AntIcons.tags_outline),
                title: Text(
                  'Categorias',
                  style: TextStyle(color: Color(0xFF293845), fontSize: 20),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoriasTela()));
                },
              ),
            ],
          ),
        ),
        body: ListView(children: <Widget>[
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(30, 185, 30, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF02aed4),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: SizedBox.expand(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      "Clientes",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ClienteTela()));
                },
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF02aed4),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: SizedBox.expand(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Vendas",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                onPressed: () => {},
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(30, 20, 30, 0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF02aed4),
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
            child: SizedBox.expand(
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Orçamentos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    )
                  ],
                ),
                onPressed: () => {},
              ),
            ),
          ),
        ]),
      ),
      onWillPop: () => _showExitDialog(),
    );
  }
}
