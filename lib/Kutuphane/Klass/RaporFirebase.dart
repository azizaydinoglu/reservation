class RaporFirebase{
  String rapor_id;
  String ogrenci_ad;
  int okul_no;
  String sinif;
  String kitap_ad;
  String ogretmen_ad;


  RaporFirebase(this.rapor_id, this.ogrenci_ad, this.okul_no, this.sinif,
      this.kitap_ad, this.ogretmen_ad);

  factory RaporFirebase.fromJson(String key, Map<dynamic, dynamic> json) {
    return RaporFirebase(
      key,
      json["ogrenci_ad"] as String,
      json["okul_no"] as int,
      json["sinif"] as String,
      json["kitap_ad"] as String,
      json["ogretmen_ad"] as String,


    );
  }




}