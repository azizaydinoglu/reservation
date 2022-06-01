class KitapFirebase {
  String kitap_id;
  int barkod_no;
  String ad;
  String yazar;
  String durum;
  String kategori;
  int sayfasayisi;

  KitapFirebase(this.kitap_id, this.barkod_no, this.ad, this.yazar, this.durum,
      this.kategori, this.sayfasayisi);

  factory KitapFirebase.fromJson(String key, Map<dynamic, dynamic> json) {
    return KitapFirebase(
        key,
        json["barkod_no"] as int,
        json["ad"] as String,
        json["yazar"] as String,
        json["durum"] as String,
        json["kategori"] as String,
        json["sayfasayisi"] as int);
  }


}
