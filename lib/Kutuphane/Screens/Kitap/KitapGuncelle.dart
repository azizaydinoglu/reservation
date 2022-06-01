import 'dart:collection';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservation/Kutuphane/Klass/Kategori.dart';
import 'package:reservation/Kutuphane/Klass/KitapFirebase.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/Kitap.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/Kitaplar.dart';

class KitapGuncelle extends StatefulWidget {
  KitapFirebase kitap;
  KitapGuncelle({this.kitap});

  @override
  _KitapGuncelleState createState() => _KitapGuncelleState();
}

class _KitapGuncelleState extends State<KitapGuncelle> {
  var tfkitapAd = TextEditingController();
  var tfyazar = TextEditingController();
  var tfsayfasayi = TextEditingController();
  var tfbarcode = TextEditingController();
  String barcode;
  var secilenDeger;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refKitaplar = FirebaseDatabase.instance.reference().child("Kitap");
  var refKategori =
      FirebaseDatabase.instance.reference().child("ayarlarkategori");

  Future<void> guncelle(String kitap_id, String ad, int barkod_no,
      int sayfasayisi, String kategori, String yazar) async {
    var bilgi = HashMap<String, dynamic>();

    bilgi["kitap_id"] = kitap_id;
    bilgi["ad"] = ad;
    bilgi["barkod_no"] = barkod_no;
    bilgi["kategori"] = kategori;
    bilgi["sayfasayisi"] = sayfasayisi;
    bilgi["yazar"] = yazar;

    refKitaplar.child(kitap_id).update(bilgi);

    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tfkitapAd.text = widget.kitap.ad;
    tfyazar.text = widget.kitap.yazar;
    tfsayfasayi.text = widget.kitap.sayfasayisi.toString();
    tfbarcode.text = widget.kitap.barkod_no.toString();
    secilenDeger = widget.kitap.kategori;
  }

  @override
  Widget build(BuildContext context) {
    var ekranGenisligi = MediaQuery.of(context).size.width;
    var ekranYuksekligi = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Güncelle"),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top: ekranYuksekligi/25),
          child: Center(
            child: SizedBox(
              width: ekranGenisligi/1.2,
              height: ekranYuksekligi/1.3,
              child: Card(
                elevation: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfbarcode,
                          decoration: InputDecoration(

                            labelText: "barkod okutunuz",
                          ),
                        ),
                      ),
                    ), //barkod no
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfkitapAd,
                          decoration: InputDecoration(
                            labelText: "kitap adı",
                          ),
                        ),
                      ),
                    ), //kitap adı
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfyazar,
                          decoration: InputDecoration(
                            labelText: "yazar adı ",
                          ),
                        ),
                      ),
                    ), //yazar
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfsayfasayi,
                          decoration: InputDecoration(
                            labelText: "sayfa sayısı",
                          ),
                        ),
                      ),
                    ), //sayfa sayısı
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: StreamBuilder<Event>(
                          stream: refKategori.onValue,
                          builder: (context, event) {
                            if (event.hasData) {
                              var kategorilerListesi = List<Kategori>();

                              var gelenKategoriler = event.data.snapshot.value;
                              if (gelenKategoriler != null) {
                                gelenKategoriler.forEach((key, nesne) {
                                  var gelenKategori = Kategori.fromJson(key, nesne);
                                  kategorilerListesi.add(gelenKategori);

                                  //Dropdownda Tür isimlerine göre sıralanıyor

                                  kategorilerListesi
                                      .sort((a, b) => a.tur.compareTo(b.tur));
                                });
                              }
                              return SizedBox(
                                width: ekranGenisligi / 1.644,
                                height: MediaQuery.of(context).size.height / 12,
                                child: DropdownButton(
                                  underline: Container(
                                    height: 1,
                                    color: Colors.teal,
                                  ),
                                  hint: Text("kategori seçiniz"),
                                  value: secilenDeger,
                                  items: kategorilerListesi.map((value) {
                                    return DropdownMenuItem(
                                        value: value.tur,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(value.tur),
                                        ));
                                  }).toList(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.teal,
                                  ),
                                  onChanged: (secilenVeri) {
                                    setState(() {
                                      secilenDeger = secilenVeri;
                                    });
                                  },
                                ),
                              );
                            } else {
                              return Center();
                            }
                          },
                        ),
                      ),
                    ), // kategori
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          onPressed: () {
                            if (tfbarcode != null &&
                                tfkitapAd != null &&
                                secilenDeger != null) {
                              setState(() {
                                //  kitapKayit(int.parse(tfbarcode.text), tfkitapAd.text, tfyazar.text, secilenDeger, int.parse(tfsayfasayi.text));

                                guncelle(
                                    widget.kitap.kitap_id,
                                    tfkitapAd.text,
                                    int.parse(tfbarcode.text),
                                    int.parse(tfsayfasayi.text),
                                    secilenDeger,
                                    tfyazar.text);

                                tfbarcode.clear();
                                tfkitapAd.clear();
                                tfyazar.clear();
                                secilenDeger = null;
                                tfsayfasayi.clear();
                              });
                            } else {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Bilgileri Eksiksiz Doldurun !"),
                              ));
                            }
                          },
                          child: Text("Güncelle")),
                    ), //Güncelle button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}
