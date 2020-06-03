import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/geeta.dart';
import '../util/getData.dart';
import '../util/initialGetters.dart';
import '../widgets/datalist.dart';

import '../geeta.dart';
import '../util/db.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _controller = new PageController();
  static int currentPage = 0;
  Future<bool> _copy;
  Future<double> _font;
  Future<List<Geeta>> _geeta;
  Future<int> _lang;
  @override
  void initState() {
    super.initState();
    _copy = creData().then((onValue) {
      _geeta = getData(currentPage + 1);
      return onValue;
    });
    _lang = getLang();
    _font = getFont();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _font = getFont();
  }

  Future<bool> creData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int isDbinserted = prefs.getInt("database");
    if(isDbinserted==null){
    await Future.forEach(GEETA,(element) async {
      await createData(Geeta(
          book: element["book"],
          chapter: element["chapter"],
          verse: element["verse"],
          nepali: element["nepali"],
          sanskrit: element["sanskrit"],
          english: element["english"]));
    });
    await prefs.setInt("database", 1);
    }
    print('result');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        leading: CupertinoButton(
          child: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (currentPage > 0) {
              _controller.jumpToPage(currentPage - 1);
            }
          },
        ),
        middle: Text('Geeta' + '\t[${currentPage + 1}]'),
        trailing: CupertinoButton(
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () {
            if (currentPage < 17) {
              _controller.jumpToPage(currentPage + 1);
            }
          },
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            itemCount: 18,
            controller: _controller,
            itemBuilder: (ct, j) => FutureBuilder(
                future: _copy,
                builder: (context, snapsot) {
                  if (!snapsot.hasData) {
                    return Center(
                      child: Text('Database'),
                    );
                  }
                  if (snapsot.hasData) {
                    return FutureBuilder(
                      future: Future.wait([_geeta, _font, _lang]),
                      builder: (ctx, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        }
                        final data = snapshot.data[0];
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (ctx, i) {
                            final String langData = snapshot.data[2] == 0
                                ? data[i].nepali
                                : data[i].english;
                            return InkWell(
                              child: buildData(
                                  data[i].sanskrit,
                                  langData,
                                  snapshot.data[1],
                                  Colors.white,
                                  data[i].color),
                              onTap: () => {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (ctx) {
                                    return CupertinoActionSheet(
                                      title: Text('Actions'),
                                      // message: Text('Message'),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Clipboard.setData(new ClipboardData(
                                                text: data[i].sanskrit +
                                                    langData +
                                                    ' Additional text here'));
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text('Copy'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            Share.share(data[i].sanskrit +
                                                langData +
                                                ' Additional text here');
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text('Share'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            await addBookmark(
                                                currentPage + 1, data[i].verse);
                                            Navigator.of(ctx).pop();
                                          },
                                          child: Text('Favorite'),
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
                              },
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Error'));
                  }
                }),
            onPageChanged: (page) {
              setState(() {
                currentPage = page;
                _geeta = getData(currentPage + 1);
              });
            },
          ),
        ),
      ),
    );
  }
}
