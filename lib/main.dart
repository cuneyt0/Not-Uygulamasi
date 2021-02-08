import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_odev/utils/databaseHelper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sqflite/sqflite.dart';

import 'GridGorunum.dart';
import 'NotEkleSayfasi.dart';
import 'models/NoteColors.dart';
import 'models/Notlar.dart';
import 'notIcerik.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MyHomePage(),
        "/gridGorunum": (context) => GridGorunum(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.orangeAccent,
      ),
      //home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Notlar> tumnotlar;
  DatabaseHelper databasehelper;
  var scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumnotlar = List<Notlar>();
    databasehelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          title: notHeader(),
          backgroundColor: Colors.white70,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: ListTile(
                        title: Text("Izgara Görünümü"),
                        onTap: () {
                          Navigator.of(context).popUntil((route) =>
                          route.isFirst);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GridGorunum()));
                        },
                      ))
                ];
              },
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _notEkle(context);
            },
            child: Icon(Icons.create)),
        body: FutureBuilder(
          future: databasehelper.notlariIcerenListe(),
          builder: (context, AsyncSnapshot<List<Notlar>> snapShot) {
            if (snapShot.data.isNotEmpty &&
                snapShot.connectionState == ConnectionState.done) {
              tumnotlar = snapShot.data;

              return ListView.builder(
                  itemCount: tumnotlar.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      movementDuration: Duration(milliseconds: 2000),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete),
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                      ),
                      onDismissed: (direction) {
                        _notsil(tumnotlar[index].notId);
                        setState(() {
                          scaffoldkey.currentState.showSnackBar(SnackBar(
                            backgroundColor: Colors.blue[100 * (index % 5)],
                            content: Text(
                                tumnotlar[index].notBaslik + "  notu silindi"),
                            duration: Duration(seconds: 2),
                          ));
                        });
                      },

                      child: Card(
                        color: Colors.blue[100 * (index % 5)],
                        child: ListTile(
                          onTap: () {
                            NotIcerikSayfasinaGitt(context, tumnotlar[index]);
                          },
                          leading: oncelikIconu(tumnotlar[index].notOncelik),
                          title: Text(
                            tumnotlar[index].notBaslik,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Baslik"),
                          ),
                          subtitle: Text(
                            databasehelper.dateFormat(
                              DateTime.parse(
                                tumnotlar[index].notTarih,
                              ),
                            ),
                            style: TextStyle(fontFamily: ""),
                          ),
                          trailing: GestureDetector(
                              onTap: () =>
                                  _detaysayfasinagit(context, tumnotlar[index]),
                              child: Icon(
                                Icons.update,
                                color: Colors.indigo,
                                size: 35,
                              )),
                        ),
                      ),
                    );
                  });
            } else if (snapShot.data.isEmpty) {
              return Center(
                child: _giris(context),
              );
            } else {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ));
  }

  void _notsil(int notId) async {
    await databasehelper.notSil(notId).then((silinenNotId) {
      if (silinenNotId != 0) {
        debugPrint("Basarıyla Silindi: $silinenNotId");
        setState(() {});
      }
    });
  }

  oncelikIconu(int notOncelik) {
    switch (notOncelik) {
      case 0:
        return CircleAvatar(
          radius: 26,
          child: Text(
            "Az",
          ),
          backgroundColor: Colors.blueGrey.shade200,
        );
        break;
      case 1:
        return CircleAvatar(
          radius: 26,
          child: Text(
            "ORTA",
          ),
          backgroundColor: Colors.blueGrey.shade200,
        );
        break;
      case 2:
        return CircleAvatar(
          radius: 26,
          child: Text(
            "ACİL",
          ),
          backgroundColor: Colors.blueGrey.shade200,
        );
        break;
    }
  }

  _detaysayfasinagit(BuildContext context, Notlar not) {
    /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotEkleSayfasi(
                  baslik: "Not Güncelle",
                  duzenlenecekNot: not,
                )));*/

    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.topToBottom,
            child: NotEkleSayfasi(
              baslik: "Not Güncelle",
              duzenlenecekNot: not,
            )));
  }

  void NotIcerikSayfasinaGitt(BuildContext context, Notlar notId) {
    /* Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotIcerik(
                  notId: notId,
                )));*/
    Navigator.push(
        context,
        PageTransition(
            child: NotIcerik(notId: notId),
            type: PageTransitionType.leftToRight));
  }


  void _notEkle(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                NotEkleSayfasi(
                  baslik: "Not Oluştur",
                ))).then((value) {
      setState(() {});
    });
  }

  _giris(BuildContext context) {
    return ListView(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/Images/cry.png",
                fit: BoxFit.cover,
                width: 600,
                height: 350,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "       Notunuz bulunmamaktadır\n\nTuşa basarak",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Icerik")),
                    TextSpan(
                        text: " + ",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _notEkle(context);
                          }),
                    TextSpan(
                        text: " not ekleyebilirsiniz",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: "Icerik")),
                  ])),
            )
          ],
        )
      ],
    );
  }

  /* noteList(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: notRenkleri[(index % notRenkleri.length).floor()],
          borderRadius: BorderRadius.circular(5.5),
        ),
        height: 100,
        child: Center(
          child: Row(
            children: [
              Container(
                color: notMarginRenk[(index % notMarginRenk.length).floor()],
                width: 3.5,
                height: double.infinity,
              ),
              Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Flexible(child: Text(tumnotlar[index].notBaslik),)],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}*/

  Widget notHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 2.5, right: 2.5),
      child: Column(
        children: [
          Text(
            "NOTE UYGULAMASI",
            style: TextStyle(
              color: Colors.red,
              fontSize: 25,
              fontWeight: FontWeight.w700,
              fontFamily: "Baslik",
            ),
          ),
          Divider(
            color: Colors.blueAccent,
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}