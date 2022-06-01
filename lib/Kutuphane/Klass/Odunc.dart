class Odunc {
  String odunc_id;
  String tarih;
  int odunc_sure;
  String sinif;
  String ogrenci_ad;
  int okul_no;
  String ogretmen_ad;
  String kitap_ad;
  String kitap_id;
  Odunc(this.odunc_id, this.tarih, this.odunc_sure, this.sinif, this.ogrenci_ad,
      this.okul_no, this.ogretmen_ad, this.kitap_ad, this.kitap_id);

  factory Odunc.fromJson(String key, Map<dynamic, dynamic> json) {
    return Odunc(
      key,
      json["tarih"] as String,
      json["odunc_sure"] as int,
      json["sinif"] as String,
      json["ogrenci_ad"] as String,
      json["okul_no"] as int,
      json["ogretmen_ad"] as String,
      json["kitap_ad"] as String,
      json["kitap_id"] as String,
    );
  }
}
