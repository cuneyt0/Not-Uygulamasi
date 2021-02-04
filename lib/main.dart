import 'package:flutter/material.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';
import 'package:sqflite/sqflite.dart';

import 'GridGorunum.dart';
import 'NotEkleSayfasi.dart';
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
        "/":(context)=>MyHomePage(),
        "/gridGorunum":(context)=>GridGorunum(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        accentColor: Colors.deepOrangeAccent,
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
        title: Text("Not Defteri"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: ListTile(
                  title: Text("Izgara Görünümü"),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>GridGorunum()));
                  } ,
                ))
              ];
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotEkleSayfasi(
                          baslik: "Yeni Not",
                        )));
          },
          child: Icon(Icons.add)),
      body: FutureBuilder(
        future: databasehelper.notlariIcerenListe(),
        builder: (context, AsyncSnapshot<List<Notlar>> snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            tumnotlar = snapShot.data;
            return ListView.builder(
                itemCount: tumnotlar.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(tumnotlar[index].notId.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      _notsil(tumnotlar[index].notId);
                    },
                    child: Card(
                      color: tumnotlar[index].notId % 1 == 0
                          ? Colors.white54
                          : Colors.greenAccent,
                      child: ListTile(
                        onTap: () {
                          NotIcerikSayfasinaGitt(context,tumnotlar[index]);
                        },
                        leading: oncelikIconu(tumnotlar[index].notOncelik),
                        title: Text(
                          tumnotlar[index].notBaslik,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          databasehelper.dateFormat(
                            DateTime.parse(tumnotlar[index].notTarih),
                          ),
                        ),
                        trailing: GestureDetector(
                            onTap: () =>
                                _detaysayfasinagit(context, tumnotlar[index]),
                            child: Icon(Icons.update)),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NotEkleSayfasi(
                  baslik: "Not Güncelle",
                  duzenlenecekNot: not,
                )));
  }

  /*void NotIcerikSayfasinaGit(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NotIcerik()));
  }*/

  void NotIcerikSayfasinaGitt(BuildContext context, Notlar notId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>NotIcerik(notId: notId,)));

  }




}
