class Sinif{
  String id;
  String sinif;


  Sinif(this.id, this.sinif);



  factory Sinif.fromJson(String key, Map<dynamic, dynamic> json) {
    return Sinif(key,json["sinif"] as String);
  }

}