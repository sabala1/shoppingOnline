import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/sqlite.dart';

class SQLite {
  final String nameDatabase = 'shoppingonline.db';
  final int version = 1;
  final String tableDatabase = 'tableOrder';
  final String columnId = 'id';
  final String columnIdSeller = 'idSeller';
  final String columnIdProduct = 'idProduct';
  final String columnName = 'name';
  final String columnPrice = 'price';
  final String columnAmount = 'amount';
  final String columnSum = 'sum';

  SQLite() {
    initialDatabase();
  }

  Future<Null> initialDatabase() async {
    await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE $tableDatabase ($columnId INTEGER PRIMARY KEY, $columnIdSeller TEXT, $columnIdProduct TEXT, $columnName TEXT, $columnPrice TEXT, $columnAmount TEXT, $columnSum TEXT)'),
      version: version,
    );
  }

  Future<Database> connectedDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
    );
  }

  Future<List<SQLiteModel>> readSQLite() async {
    Database database = await connectedDatabase();
    List<SQLiteModel> results = [];
    List<Map<String, dynamic>> maps = await database.query(tableDatabase);
    print('### maps on SQLitHelper ==>> $maps');
    for (var item in maps) {
      SQLiteModel model = SQLiteModel.fromMap(item);
      results.add(model);
    }
    return results;
  }

  Future<Null> insertValueToSQLite(SQLiteModel sqLiteModel) async {
    Database database = await connectedDatabase();
    await database.insert(tableDatabase, sqLiteModel.toMap()).then(
        (value) => print('### insert Value name ==>> ${sqLiteModel.name}'));
  }

  Future<void> deleteSQLiteWhereId(int id) async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase, where: '$columnId = $id')
        .then((value) => print('### Success Delete id ==> $id'));
  }

  Future<void> emptySQLite() async {
    Database database = await connectedDatabase();
    await database
        .delete(tableDatabase)
        .then((value) => print('### Empty SQLite Success'));
  }
}
