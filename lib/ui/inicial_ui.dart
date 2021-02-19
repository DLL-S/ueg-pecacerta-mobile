import 'package:ant_icons/ant_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peca_certa_app/ui/categorias_ui.dart';
import 'package:peca_certa_app/ui/marcas_ui.dart';
import 'package:peca_certa_app/ui/produtos_ui.dart';

class PaginaInicial extends StatefulWidget {
  @override
  _PaginaInicialState createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Página Inicial"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.notifications,
                ),
              )),
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_vert,
                ),
              )),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CategoriasTela()));
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
            child: FlatButton(
              color: Theme.of(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Clientes",
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
            child: FlatButton(
              color: Theme.of(context).primaryColor,
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
            child: FlatButton(
              color: Theme.of(context).primaryColor,
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
    );
  }
}
