import 'package:flutter/material.dart';
import 'package:peca_certa_app/ui/login_pagina.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

const request = "https://10.0.2.2:8080/api/v1/";
void main() async {
  //HttpOverrides.global = new MyHttpOverrides();
  http.Response response = await http.get(request + "produtos");
  print(response.body);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peca Certa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Helvetica",
        primaryColor: Color(0xFF18778C),
        backgroundColor: Color(0xFFDFE6ED),
      ),
      home: LoginPagina(),
    );
  }
}
