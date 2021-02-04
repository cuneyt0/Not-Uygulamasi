import 'package:flutter/material.dart';
import 'package:flutter_odev/main.dart';
import 'package:flutter_odev/models/kategoriler.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';

class KategorilerSayfasi extends StatefulWidget {
  @override
  _KategorilerSayfasiState createState() => _KategorilerSayfasiState();
}

class _KategorilerSayfasiState extends State<KategorilerSayfasi> {
  List<Kategori> tumKategoriler;
  DatabaseHelper databaseHelper;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    if (tumKategoriler == null) {
      tumKategoriler = List<Kategori>();
      kategoriListesiniGuncelle();

    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Kategori Listesi"),
        ),
        body: ListView.builder(
          itemCount: tumKategoriler.length,
          itemBuilder: (context, index) {
            return ListTile(

              title: Text(tumKategoriler[index].kategoriBaslik),
              trailing: GestureDetector(
                  onTap: () {
                    kategorisil(tumKategoriler[index].kategoriId);
                  },
                  child: Icon(Icons.delete)),
              leading: Icon(Icons.import_contacts),
            );
          },
        ));
  }

  void kategoriListesiniGuncelle() {
    databaseHelper.kategoriListesiniGetir().then((kategorileriIcerenList) {
      setState(() {
        tumKategoriler = kategorileriIcerenList;
      });
    });
  }

 kategorisil(int kategoriId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "KategoriSil",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w700,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "Kategoriyi sildiginiz zaman ilgili tün notlar silinecektir!!"),
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
                        databaseHelper.kategoriSil(kategoriId).then((value) {
                          if (value != 0) {
                            setState(() {
                              kategoriListesiniGuncelle();
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage()));
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





}
