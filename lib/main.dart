import 'package:flutter/material.dart';
import 'package:peca_certa_app/ui/login_ui.dart';

void main() async {
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
