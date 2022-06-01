class Rezervasyon {
  String rezervasyon_id;
  String ogretmen_ad;
  String saat;
  String tarih;

  Rezervasyon(this.rezervasyon_id,this.ogretmen_ad, this.saat, this.tarih);

  factory Rezervasyon.fromJson(String key, Map<dynamic, dynamic> json) {
    return Rezervasyon(key,json["ogretmen_ad"] as String, json["saat"] as String, json["tarih"] as String);
  }
}
