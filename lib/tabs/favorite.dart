import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/getData.dart';
import '../widgets/datalist.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  int id;
  int chapter;
  int verse;
  int _val;
  Future<int> _lang;
  Future<List<dynamic>> _data;
  Future<int> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _val = prefs.getInt('lang') ?? 0;
    return _val;
  }

  @override
  void initState() {
    super.initState();
    _data = getBook();
    _lang = getLang();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Favorites'),
        trailing: CupertinoButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              _data = getBook();
            });
          },
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
              future: Future.wait([_data, _lang]),
              builder: (ctx, snapsot) {
                if (!snapsot.hasData) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                final snapshot = snapsot.data[0];
                if (snapshot.length == 0) {
                  return Center(
                    child: Text('No Bookmarks'),
                  );
                }
                final items = snapshot;
                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      final String langData =
                          _val == 0 ? item.nepali : item.english;
                      print(item.nepali);
                      return buildData(
                          item.sanskrit, langData, 18, Colors.white, 0);
                    });
              }),
        ),
      ),
    );
  }
}
