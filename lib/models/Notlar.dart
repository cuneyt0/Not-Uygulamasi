class Notlar {
  int notId;
  int kategoriId;
  String kategoriBaslik;
  String notBaslik;
  String notIcerik;
  int notOncelik;
  String notTarih;

  Notlar(this.kategoriId,this.notBaslik, this.notIcerik, this.notOncelik,
     this.notTarih ); //db'ye veri yazma

  Notlar.withId(this.notId, this.kategoriId, this.notBaslik, this.notIcerik,
      this.notOncelik, this.notTarih); // db'den veri okurken

  //db'ye veri yazarken mapa çevirme

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map["notId"] = this.notId;
    map["kategoriId"] = this.kategoriId;
    map["notBaslik"] = this.notBaslik;
    map["notIcerik"] = this.notIcerik;
    map["notOncelik"] = this.notOncelik;
    map["notTarih"] = this.notTarih;

    return map;
  }

  //db'den gelen map yapısını notNesnesine dönüştürme

  Notlar.fromMap(Map<String,dynamic>map){

  this.notId=map["notId"];
  this.kategoriId=map["kategoriId"];
  this.kategoriBaslik=map["kategoriBaslik"];
  this.notBaslik=map["notBaslik"];
  this.notIcerik=map["notIcerik"];
  this.notOncelik=map["notOncelik"];
  this.notTarih=map["notTarih"];
  }

  @override
  String toString() {
    return 'Notlar{notId: $notId, kategoriId: $kategoriId, notBaslik: $notBaslik, notIcerik: $notIcerik, notOncelik: $notOncelik, notTarih: $notTarih}';
  }
}
