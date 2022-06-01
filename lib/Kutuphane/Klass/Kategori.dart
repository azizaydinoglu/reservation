class Kategori{
  String id;
  String tur;


  Kategori(this.id, this.tur);



  factory Kategori.fromJson(String key, Map<dynamic, dynamic> json) {
    return Kategori(key,json["tur"] as String);
  }

}