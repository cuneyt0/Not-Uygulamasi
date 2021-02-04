import 'package:flutter/material.dart';
import 'package:flutter_odev/main.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';

import 'models/Notlar.dart';

class GridGorunum extends StatefulWidget {
  @override
  _GridGorunumState createState() => _GridGorunumState();
}

class _GridGorunumState extends State<GridGorunum> {
  List<Notlar> tumnotlar;
  DatabaseHelper databasehelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databasehelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumnotlar == null) {
      tumnotlar = List<Notlar>();
      notIceriginiGetir();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Not Defteri"),
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
                        },
                      ))
                ];
              },
            )
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5, crossAxisCount: 2),
          itemCount: tumnotlar.length,

          itemBuilder: (context, index) {
            return Card(
                elevation: 30,
                color: Colors.white54,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              tumnotlar[index].notBaslik,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        tumnotlar[index].notIcerik,
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ));
          },
        ));
  }

  void notIceriginiGetir() {
    databasehelper.notlariIcerenListe().then((value) {
      setState(() {
        tumnotlar = value;
      });
    });
  }
}
