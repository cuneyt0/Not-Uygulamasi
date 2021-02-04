class Kategori{
  int kategoriId;
  String kategoriBaslik;

  //db 'e kategori ekle(veri yazma)
  Kategori(this.kategoriBaslik);

  Kategori.withId(this.kategoriId, this.kategoriBaslik);//db'den veri okurken


  //Veri tabanına veri yollayacagım zaman

  Map<String,dynamic>toMap(){

    var map =Map<String,dynamic>();

    map["kategoriId"]=kategoriId;
    map["kategoriBaslik"]=kategoriBaslik;
    return map;
  }


//db'deki mapı nesneye donusturucegım yapı
  Kategori.fromMap(Map<String,dynamic> map){

    kategoriId=map["kategoriId"];
    kategoriBaslik=map["kategoriBaslik"];
  }

  @override
  String toString() {
    return 'Kategori{kategoriId: $kategoriId, kategoriBaslik: $kategoriBaslik}';
  }
}