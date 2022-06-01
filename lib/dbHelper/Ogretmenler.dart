class Ogretmenler {
  String ogretmen_id;
  String ogretmen_ad;
  String ogretmen_sifre;
  int ogretmen_rol;


  Ogretmenler(this.ogretmen_id, this.ogretmen_ad, this.ogretmen_sifre,
      this.ogretmen_rol);


  factory Ogretmenler.fromJson(String key, Map<dynamic, dynamic> json) {
    return Ogretmenler(
        key, json["ogretmen_ad"] as String, json["ogretmen_sifre"] as String,json["ogretmen_rol"] as int) ;
  }
}
