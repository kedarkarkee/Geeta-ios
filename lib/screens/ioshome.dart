import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../tabs/settings.dart';
import '../tabs/home.dart';
import '../tabs/favorite.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> widgets = [
    Home(),
    Favorites(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
      ),
      tabBuilder: (ctx, index) {
        return CupertinoTabView(builder: (cttx) {
          return widgets[index];
        });
      },
    );
  }
}
