import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import '../models/geeta.dart';
var run = 0;
Future<int> createData(Geeta data1)async{
final Future<Database> database = openDatabase(Path.join(await getDatabasesPath(),'geeta.db'),
onCreate: (db,version){
  //return db.execute('CREATE TABLE IF NOT EXISTS "note" (	"book"	INTEGER,	"chapter"	INTEGER,	"verse"	INTEGER,	"nepali"	TEXT,	"english"	TEXT,	PRIMARY KEY("book"))',);
  return db.execute('CREATE TABLE "geeta" ("id" INTEGER,	"book"	INTEGER,	"chapter"	INTEGER,	"verse"	INTEGER,	"nepali"	TEXT,	"sanskrit"	TEXT, "english" TEXT, "isBookmark" INTEGER DEFAULT 0, "color" INTEGER DEFAULT 0,	PRIMARY KEY("id"))');
},
version: 1,
);
Future<int> insertData(Geeta dd)async{
  final Database db = await database;
  int result = await db.insert('geeta', dd.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  run++;
print(run);
return result;
}
return (await insertData(data1));
}