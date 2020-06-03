
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../geeta.dart';
import '../util/db.dart';
import '../models/geeta.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> language = ['Nepali', 'English'];
  int _lang;
  Future<double> fontSize;
  Future<int> lang;
  double _value;
  @override
  void initState() {
    super.initState();
    fontSize = getFont();
    lang = getLang();
  }

  Future<double> getFont() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _value = prefs.getDouble('fontSize') ?? 18.0;
    return _value;
  }

  Future<int> getLang() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _lang = prefs.getInt('lang') ?? 0;
    return _lang;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
      ),
      child: SafeArea(
        child: FutureBuilder(
            future: Future.wait([fontSize, lang]),
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionTile(
                      title: Text('Font Size'),
                      trailing: Text(_value.round().toString()),
                      children: <Widget>[
                        CupertinoSlider(
                          min: 5,
                          max: 25,
                          value: _value,
                          onChanged: (val) {
                            setState(() {
                              _value = val;
                            });
                          },
                        ),
                        CupertinoButton(
                            child: Text('Save'),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setDouble('fontSize', _value);
                            }),
                      ],
                    ),
                    InkWell(
                        child: ListTile(
                          title: Text('Language'),
                          trailing: Text(language[_lang]),
                        ),
                        onTap: () => {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (ctx) {
                                  return CupertinoActionSheet(
                                    title: Text('Choose Language'),
                                    message: Text('Message'),
                                    actions: <Widget>[
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setInt('lang', 0);
                                          setState(() {
                                            _lang = 0;
                                            Navigator.of(ctx).pop();
                                          });
                                        },
                                        child: Text('Nepali'),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          await prefs.setInt('lang', 1);
                                          setState(() {
                                            _lang = 1;
                                            Navigator.of(ctx).pop();
                                          });
                                        },
                                        child: Text('English'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: Text('Cancel'),
                                    ),
                                  );
                                },
                              )
                            }),
                    CupertinoButton.filled(
                      child: Text('Database'),
                      onPressed: ()  {
                      GEETA.forEach((element) {
                        createData(Geeta(book: element["book"],chapter: element["chapter"], verse: element["verse"],nepali: element["nepali"],sanskrit: element["sanskrit"],english: element["english"]));
                      });
                      },
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
