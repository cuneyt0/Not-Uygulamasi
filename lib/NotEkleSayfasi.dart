import 'package:flutter/material.dart';
import 'package:flutter_odev/models/kategoriler.dart';
import 'package:flutter_odev/utils/databaseHelper.dart';

import 'kategori_islemleri.dart';
import 'main.dart';
import 'models/Notlar.dart';

class NotEkleSayfasi extends StatefulWidget {
  String baslik;
  Notlar duzenlenecekNot;

  NotEkleSayfasi({this.baslik, this.duzenlenecekNot});

  @override
  _NotEkleSayfasiState createState() => _NotEkleSayfasiState();
}

class _NotEkleSayfasiState extends State<NotEkleSayfasi> {
  DatabaseHelper databaseHelper;
  List<Kategori> tumKategoriler;
  Kategori secilenKategori;
  int KategoriId;
  var key = GlobalKey<FormState>();
  var _scafoldkey = GlobalKey<ScaffoldState>();
  static var _oncelik = ["Düşük", "Orta", "Yüksek"];
  int secilenOncelik;
  String notBaslik, notIcerik;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumKategoriler = List<Kategori>();
    databaseHelper = DatabaseHelper();
    databaseHelper.kategoriListesiniGetir().then((value) {
      tumKategoriler = value;

      if (widget.duzenlenecekNot != null) {
        KategoriId = widget.duzenlenecekNot.kategoriId;
        secilenOncelik = widget.duzenlenecekNot.notOncelik;
      } else {
        KategoriId = 1;
        secilenOncelik = 0;
        secilenKategori = tumKategoriler[0];
        debugPrint(
            "Secilen Kategoriye deger atandı" + secilenKategori.kategoriBaslik);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scafoldkey,
      appBar: AppBar(
        title: Text(widget.baslik),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text("Kategorileri Görüntüle"),
                    onTap: () {
                      Navigator.pop(context);
                       kategorilerSayfasinaGit(context);
                    },
                  ),
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
      ),
      body: tumKategoriler.length <= 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: key,
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                      margin: EdgeInsets.fromLTRB(10, 15, 0, 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: kategoriItemleriOlustur(),
                          hint: Text(
                            "Kategori seç",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          value: secilenKategori,
                          onChanged: (Kategori kullanicininSectigiKategori) {
                            setState(() {
                              secilenKategori = kullanicininSectigiKategori;
                              KategoriId =
                                  kullanicininSectigiKategori.kategoriId;
                            });
                          },
                          //dropdownColor: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot.notBaslik
                            : "",
                        validator: (icerik) {
                          if (icerik.length <= 0) {
                            return "Boş Geçemezsiniz";
                          }
                        },
                        onSaved: (icerik) {
                          notBaslik = icerik;
                        },
                        decoration: InputDecoration(
                          hintText: "Not Başlık",
                          labelText: "Başlık",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        initialValue: widget.duzenlenecekNot != null
                            ? widget.duzenlenecekNot.notIcerik
                            : "",
                        onSaved: (icerik) {
                          notIcerik = icerik;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Not İçerik",
                          labelText: "İçerik",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 12),
                      margin: EdgeInsets.fromLTRB(10, 15, 0, 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                            items: _oncelik.map((oncelik) {
                              return DropdownMenuItem<int>(
                                child: Text(oncelik),
                                value: _oncelik.indexOf(oncelik),
                              );
                            }).toList(),
                            value: secilenOncelik,
                            onChanged: (secilenOncelikId) {
                              setState(() {
                                secilenOncelik = secilenOncelikId;
                              });
                            }
                            //dropdownColor: Theme.of(context).accentColor,
                            ),
                      ),
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.end,
                      //mainAxisSize: MainAxisSize.min,
                      children: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "VAZGEÇ",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        FlatButton(
                            onPressed: () {
                              if (key.currentState.validate()) {
                                key.currentState.save();
                                var tarih = DateTime.now();
                                if (widget.duzenlenecekNot == null) {
                                  databaseHelper
                                      .notEkle(Notlar(
                                          KategoriId,
                                          notBaslik,
                                          notIcerik,
                                          secilenOncelik,
                                          tarih.toString()))
                                      .then((kayitId) {
                                    if (kayitId != 0) {
                                      debugPrint("$tarih");
                                      debugPrint(
                                          databaseHelper.dateFormat(tarih));
                                      Navigator.pop(context);
                                      //pop yap
                                    }
                                  });
                                } else {
                                  databaseHelper
                                      .notGuncelle(Notlar.withId(
                                          widget.duzenlenecekNot.notId,
                                          KategoriId,
                                          notBaslik,
                                          notIcerik,
                                          secilenOncelik,
                                          tarih.toString()))
                                      .then((value) {
                                    if (value != 0) {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              }
                            },
                            child: Text(
                              "KAYDET",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          kategoriEkleDialog(context);
        },
        child: Icon(Icons.category),
      ),
    );
  }

  kategoriItemleriOlustur() {
    return tumKategoriler.map((kategori) {
      return DropdownMenuItem<Kategori>(
        value: kategori,
        child: Text(kategori.kategoriBaslik),
      );
    }).toList();
  }

  void kategoriEkleDialog(BuildContext context) {
    var k_key = GlobalKey<FormState>();
    String yeniKategoriAdi;
    showDialog(
        barrierDismissible: false,
        context: (context),
        builder: (context) {
          return SimpleDialog(
            title: Center(
              child: Text(
                "Kategori Ekle",
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            children: [
              Form(
                key: k_key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (girilenKategoriAdi) {
                      if (girilenKategoriAdi.length <= 0) {
                        return "Boş geçmeyiniz";
                      }
                    },
                    onSaved: (yeni_deger) {
                      setState(() {
                        yeniKategoriAdi = yeni_deger;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Kategori Adı",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              ButtonBar(
                children: [
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.cyan),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "VAZGEÇ",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  OutlineButton(
                    borderSide: BorderSide(color: Colors.cyan),
                    onPressed: () {
                      if (k_key.currentState.validate()) {
                        k_key.currentState.save();
                        databaseHelper
                            .kategoriEkle(Kategori(yeniKategoriAdi))
                            .then((kategoriId) {
                          if (kategoriId > 0) {
                            _scafoldkey.currentState.showSnackBar(SnackBar(
                              content: Text("Kategori Basarıyla eklendi"),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }
                        });
                      }
                    },
                    child: Text(
                      "KAYDET",
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  kategorilerSayfasinaGit(BuildContext  context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KategorilerSayfasi()));
  }
}
