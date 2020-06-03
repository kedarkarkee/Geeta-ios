import 'package:flutter/material.dart';

 List<Color> color = [
    Colors.white,
    Color.fromRGBO(253,245,102, 1),
    Color.fromRGBO(233,148,130, 1),
    Color.fromRGBO(173,212,120,1),
    Color.fromRGBO(93,135,189, 1),
    Colors.orangeAccent,
    Color.fromRGBO(248,157,198, 1),
    Color.fromRGBO(148,197,240, 1),
  ];
Widget buildData(
    String sanskrit, String nepali, double fontSize, Color textColor,int col) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(color: textColor==Colors.grey[400]?textColor:color[col]),
    child: Column(
      children: <Widget>[
        Text(
          sanskrit??'',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          nepali??'',
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    ),
  );
}
