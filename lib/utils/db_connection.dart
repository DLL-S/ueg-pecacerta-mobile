import 'dart:io';
import 'package:peca_certa_app/models/Produto.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'peca_certa.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS Categorias ('
          'codigo INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nome TEXT NOT NULL UNIQUE'
          ');');

      await db.execute('CREATE TABLE IF NOT EXISTS Marcas ('
          'codigo INTEGER PRIMARY KEY AUTOINCREMENT,'
          'nome TEXT NOT NULL UNIQUE'
          ');');
      await db.execute('CREATE TABLE IF NOT EXISTS Produtos('
          'codigo integer PRIMARY KEY AUTOINCREMENT,'
          'codigoDeBarras CHAR(13) NOT NULL,'
          'nome TEXT NOT NULL,'
          'descricao TEXT NOT NULL,'
          'categoria INTEGER NOT NULL,'
          'marca INTEGER NOT NULL,'
          'preco real NOT NULL,'
          'qtdeEstoque integer NOT NULL,'
          ' FOREIGN KEY (categoria) REFERENCES Categoria(codigo),'
          'FOREIGN KEY (marca) REFERENCES Marca(codigo)'
          ');');
    });
  }

  insereProduto(Produto produto) async {
    final db = await database;
    final res = await db.insert('Produto', produto.toJson());

    return res;
  }

  Future<List<Produto>> listaProdutos() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM PRODUTOS");

    List<Produto> list =
        res.isNotEmpty ? res.map((c) => Produto.fromJson(c)).toList() : [];

    return list;
  }
}
