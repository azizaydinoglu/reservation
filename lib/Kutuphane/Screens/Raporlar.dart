import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation/Kutuphane/Klass/RaporFirebase.dart';

class Raporlar extends StatefulWidget {
  @override
  _RaporlarState createState() => _RaporlarState();
}

class _RaporlarState extends State<Raporlar> {

  var refRapor = FirebaseDatabase.instance.reference().child("rapor");

  int toplamKitapOkunmasayisi = 0;

  String enCokOkunanKitap = "";
  int enCokOkunanKitapSayisi = 0;

  String enCokKitapOkuyanOgrenci = "";
  int enCokKitapOkunmaSayisi = 0;

  String enCokKitapOkuyanSinif = "";
  int enCokKitapOkunmaSayisiSinif = 0;

  String enCokKitapVerenOgretmen = "";
  int enCokKitapVerenOgretmenSayisi = 0;

  Future<void> encok() async {
    refRapor.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value;
      var ogretmen = Map();
      var sinif = Map();
      var ogrenci = Map();
      var kitap=Map();
      if (gelenDegerler != null) {
        gelenDegerler.forEach((key, nesne) {
          toplamKitapOkunmasayisi++;
          var gelenRapor = RaporFirebase.fromJson(key, nesne);
          if (!ogrenci.containsKey(gelenRapor.ogrenci_ad)) {
            ogrenci[gelenRapor.ogrenci_ad] = 1;
          } else {
            ogrenci[gelenRapor.ogrenci_ad] += 1;
          }
          if (!sinif.containsKey(gelenRapor.sinif)) {
            sinif[gelenRapor.sinif] = 1;
          } else {
            sinif[gelenRapor.sinif] += 1;
          }

          if (!ogretmen.containsKey(gelenRapor.ogretmen_ad)) {
            ogretmen[gelenRapor.ogretmen_ad] = 1;
          } else {
            ogretmen[gelenRapor.ogretmen_ad] += 1;
          }


          if (!kitap.containsKey(gelenRapor.kitap_ad)) {
            kitap[gelenRapor.kitap_ad] = 1;
          } else {
            kitap[gelenRapor.kitap_ad] += 1;
          }
        });



        var siraliOgrenci = ogrenci.keys.toList(growable: false)
          ..sort((k1, k2) => ogrenci[k1].compareTo(ogrenci[k2]));
        LinkedHashMap siralanmisOgrenci = new LinkedHashMap.fromIterable(
            siraliOgrenci,
            key: (k) => k,
            value: (k) => ogrenci[k]);

        var siraliSinif = sinif.keys.toList(growable: false)
          ..sort((k1, k2) => sinif[k1].compareTo(sinif[k2]));
        LinkedHashMap siralanmisSinif = new LinkedHashMap.fromIterable(
            siraliSinif,
            key: (k) => k,
            value: (k) => sinif[k]);

        var siraliOgretmen = ogretmen.keys.toList(growable: false)
          ..sort((k1, k2) => ogretmen[k1].compareTo(ogretmen[k2]));
        LinkedHashMap siralanmisOgretmen = new LinkedHashMap.fromIterable(
            siraliOgretmen,
            key: (k) => k,
            value: (k) => ogretmen[k]);

        var siralKitap = kitap.keys.toList(growable: false)
          ..sort((k1, k2) => kitap[k1].compareTo(kitap[k2]));
        LinkedHashMap siralanmisKitap = new LinkedHashMap.fromIterable(
            siralKitap,
            key: (k) => k,
            value: (k) => kitap[k]);



        enCokKitapOkuyanOgrenci = siralanmisOgrenci.entries.last.key;
        enCokKitapOkunmaSayisi = siralanmisOgrenci.entries.last.value;

        enCokKitapOkuyanSinif = siralanmisSinif.entries.last.key;
        enCokKitapOkunmaSayisiSinif = siralanmisSinif.entries.last.value;

        enCokKitapVerenOgretmen = siralanmisOgretmen.entries.last.key;
        enCokKitapVerenOgretmenSayisi = siralanmisOgretmen.entries.last.value;

        enCokOkunanKitap = siralanmisKitap.entries.last.key;
        enCokOkunanKitapSayisi = siralanmisKitap.entries.last.value;

        if (this.mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    encok();
  }

  @override
  Widget build(BuildContext context) {
    var ekranGenisligi=MediaQuery.of(context).size.width;
    var ekranYuksekligi=MediaQuery.of(context).size.height/1.6;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(

          crossAxisCount: 2,
          childAspectRatio:ekranGenisligi /ekranYuksekligi,
          children: [
            Card(

              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.solidStar,
                      size: MediaQuery.of(context).size.height / 10,
                      color: Colors.yellow,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: 8,right: 8,bottom: 8,top:MediaQuery.of(context).size.height / 40   ),
                    child: Text(
                      "Toplam Okunan Kitap Sayısı",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 40),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 20,
                        top: MediaQuery.of(context).size.height / 50),
                    child: Text(
                      toplamKitapOkunmasayisi.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.book,
                      size: MediaQuery.of(context).size.height / 10,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  Text(
                    "En Çok Okunan Kitap",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(enCokOkunanKitap),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      enCokOkunanKitapSayisi.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.userGraduate,
                      size: MediaQuery.of(context).size.height / 10,
                      color: Colors.amber,
                    ),
                  ),
                  Text(
                    "En Çok Kitap Okuyan Öğrenci",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(enCokKitapOkuyanOgrenci),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      enCokKitapOkunmaSayisi.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.userFriends,
                      size: MediaQuery.of(context).size.height / 10,
                      color: Colors.indigo,
                    ),
                  ),
                  Text(
                    "En Çok Kitap Okuyan Sınıf",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(enCokKitapOkuyanSinif),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      enCokKitapOkunmaSayisiSinif.toString(),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FaIcon(
                      FontAwesomeIcons.chalkboardTeacher,
                      size: MediaQuery.of(context).size.height / 10,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "En Çok Kitap Veren Öğretmen",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 40),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(enCokKitapVerenOgretmen),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      enCokKitapVerenOgretmenSayisi.toString(),
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
