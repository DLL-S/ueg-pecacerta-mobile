import 'package:flutter/material.dart';

class SobreTela extends StatefulWidget {
  @override
  _SobreTelaState createState() => _SobreTelaState();
}

class _SobreTelaState extends State<SobreTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Sobre"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    fit: BoxFit.contain, image: AssetImage("assets/logo.png")),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Text("Peça Certa - App",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "A PeçaCerta – Auto Peças, é uma revenda de peças para veículos pequenos, médios e grandes entre veículos de passeio e de trabalho. Com mais de 20 anos de mercado, possui uma vasta gama de produtos em seu estoque, das mais variadas marcas e modelos existentes. Seus clientes são consumidores à varejo em busca de peças para conserto de veículos e até mesmo grandes empresas que buscam peças para repor peças defeituosas da sua frota de veículos.",
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: Colors.black),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Desenvolvido por: ",
                        style: TextStyle(
                            fontSize: 12, fontStyle: FontStyle.italic),
                      ),
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: AssetImage("assets/DLLSLogo.gif")),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
