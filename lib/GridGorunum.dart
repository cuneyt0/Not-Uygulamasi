import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_odev/main.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'NotEkleSayfasi.dart';
import 'models/Notlar.dart';

class GridGorunum extends StatefulWidget {
  @override
  _GridGorunumState createState() => _GridGorunumState();
}

class _GridGorunumState extends State<GridGorunum> {
  List<Notlar> tumnotlar;
  DatabaseHelper databasehelper;
  var scaffold_key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumnotlar = List<Notlar>();
    databasehelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    /* if (tumnotlar == null) {
      setState(() {
        tumnotlar = List<Notlar>();

        notIceriginiGetir();
      });
    }*/
    return Scaffold(
        key: scaffold_key,
        appBar: AppBar(
          title: notHeader(),
          backgroundColor: Colors.white70,
          actions: [
            PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                      child: ListTile(
                    title: Text("Normal Görünümü"),
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, "/");
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=>deneme()));
                    },
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
                          ))).then((value) {
                setState(() {

                });
              });
            },
            child: Icon(Icons.add)),
        body: FutureBuilder(
            future: databasehelper.notlariIcerenListe(),
            builder: (context, AsyncSnapshot<List<Notlar>> snapShot) {
              if (snapShot.data.isNotEmpty &&
                  snapShot.connectionState == ConnectionState.done) {
                tumnotlar = snapShot.data;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 5, crossAxisCount: 2),
                  itemCount: tumnotlar.length,
                  itemBuilder: (context, index) {
                    return Card(

                      elevation: 50,
                      color: Colors.brown.shade400,
                      child: GestureDetector(
                        onLongPress: () {
                          _notsil(tumnotlar[index].notId);
                        },
                        child: SingleChildScrollView(
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Center(
                                  child: Text(
                                    tumnotlar[index].notBaslik.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      fontFamily: "Baslik",
                                      //decoration: TextDecoration.underline,
                                    ),


                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    tumnotlar[index].notIcerik,
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Icerik'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapShot.data.isEmpty) {
                return Center(
                  child: giris(),
                );
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

 /* notIceriginiGetir() {
    databasehelper.notlariIcerenListe().then((value) {
      setState(() {
        tumnotlar = value;
      });
    });
  }*/

  void _notsil(int notId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Not Sil",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Notu Silmek Istediginize Eminmisiniz"),
                ButtonBar(
                  children: [
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "IPTAL",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        databasehelper.notSil(notId).then((value) {
                          if (value != 0) {
                            scaffold_key.currentState.showSnackBar(SnackBar(
                                content: Text("Not Başarıyla silindi")));
                            setState(() {
                              Navigator.of(context).pop();
                            });
                          }
                        });
                      },
                      child: Text(
                        "SIL",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontSize: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  giris() {
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
                        style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: "Icerik")),
                    TextSpan(
                        text: " +",
                        style: TextStyle(color: Colors.blue, fontSize: 30),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NotEkleSayfasi(baslik: "Yeni Not",)));

                          }),
                    TextSpan(
                        text: " not ekleyebilirsiniz",
                        style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: "Icerik")),
                  ])),
            )
          ],
        )
      ],
    );
  }
}
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
