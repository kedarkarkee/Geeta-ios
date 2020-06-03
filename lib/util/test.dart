import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import '../models/geeta.dart';
Future<List<Geeta>> getData(int chapter) async {
  final Future<Database> database = openDatabase(
    Path.join(await getDatabasesPath(), 'geeta.db'),
  );
  final Database db = await database;
  final List<Map<String, dynamic>> maps = await db.query('geeta',where: 'book=? and chapter=?', whereArgs: [7,chapter]);
  await db.close();
  return List.generate(maps.length, (i){
    return Geeta(book: maps[i]['book'],chapter: maps[i]['chapter'],verse: maps[i]['verse'],sanskrit: maps[i]['sanskrit'],nepali: maps[i]['nepali'],english: maps[i]['english'],color: maps[i]['color']);
  });
}