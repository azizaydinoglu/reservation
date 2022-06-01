import 'dart:collection';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reservation/Kutuphane/Klass/KitapFirebase.dart';
import 'package:reservation/Kutuphane/Klass/Sinif.dart';
import 'package:reservation/OgretmenDurum.dart';

class OduncVer extends StatefulWidget {
  KitapFirebase kitap;
  OduncVer({this.kitap});

  @override
  _OduncVerState createState() => _OduncVerState();
}

class _OduncVerState extends State<OduncVer> {
  var secilenDeger;
  var tfOgrenciAdSoyad = TextEditingController();
  var tfOkulNo = TextEditingController();
  var tfSure = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refOdunc = FirebaseDatabase.instance.reference().child("odunc");
  var refSinif = FirebaseDatabase.instance.reference().child("sinif");
  var refKitaplar = FirebaseDatabase.instance.reference().child("Kitap");

  Future<void> oduncVer(
      String ogrenci_ad,
      String sinif,
      int odunc_sure,
      int okul_no,
      String tarih,
      String ogretmen_ad,
      String kitap_ad,
      String kitap_id) async {
    var bilgi = HashMap<String, dynamic>();

    bilgi["odunc_id"] = "";
    bilgi["ogrenci_ad"] = ogrenci_ad;
    bilgi["sinif"] = sinif;
    bilgi["odunc_sure"] = odunc_sure;
    bilgi["okul_no"] = okul_no;
    bilgi["tarih"] = tarih;
    bilgi["ogretmen_ad"] = ogretmen_ad;
    bilgi["kitap_ad"] = kitap_ad;
    bilgi["kitap_id"] = kitap_id;

    refOdunc.push().set(bilgi);
    Navigator.pop(context);




  }




  @override
  Widget build(BuildContext context) {
    var ekranGenisligi = MediaQuery.of(context).size.width;
    var ekranYuksekligi = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Kitap Ödünç Ver"),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.only(top: ekranYuksekligi/20),
            child: SizedBox(
              width: ekranGenisligi/1.2,
              child: Card(
                elevation: 5,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: ekranYuksekligi / 15, bottom: ekranYuksekligi / 30),
                      child: SizedBox(
                          width: ekranGenisligi / 2,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.kitap.ad,
                                style: TextStyle(
                                    fontSize: ekranGenisligi / 20,
                                    color: Colors.teal,
                                    ),
                              ))),
                    ), //Kitap Adı
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfOgrenciAdSoyad,
                          decoration: InputDecoration(
                            labelText: "öğrenci ad soyad",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ), //Öğrenci Ad Soyad
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: StreamBuilder<Event>(
                          stream: refSinif.onValue,
                          builder: (context, event) {
                            if (event.hasData) {
                              var siniflarListesi = List<Sinif>();

                              var gelenSiniflar = event.data.snapshot.value;
                              if (gelenSiniflar != null) {
                                gelenSiniflar.forEach((key, nesne) {
                                  var gelenSinif = Sinif.fromJson(key, nesne);

                                  siniflarListesi.add(gelenSinif);

                                  //Dropdownda Sınıf isimlerine göre sıralanıyor

                                  siniflarListesi
                                      .sort((a, b) => a.sinif.compareTo(b.sinif));
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
                                  hint: Text("Sınıf Seçiniz",style: TextStyle(fontSize: 15),),

                                  value: secilenDeger,
                                  items: siniflarListesi.map((value) {
                                    return DropdownMenuItem(
                                        value: value.sinif,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: ekranGenisligi / 3),
                                          child: Text(value.sinif),
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
                    ), // Sınıflar
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfOkulNo,
                          decoration: InputDecoration(
                            labelText: "okul no",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ), //Öğrenci Okul No
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfSure,
                          decoration: InputDecoration(
                            labelText: "ödünç süresi (gün)",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ), //Ödünç Süresi
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          onPressed: () {
                            if (tfOgrenciAdSoyad != null &&
                                tfOkulNo != null &&
                                tfSure != null &&
                                secilenDeger != null) {
                              setState(() {
                                var today =  DateTime.now();
                                var format=DateFormat("dd/MM/yyyy");
                                String bugun=format.format(today);

                                oduncVer(
                                    tfOgrenciAdSoyad.text,
                                    secilenDeger,
                                    int.parse(tfSure.text),
                                    int.parse(tfOkulNo.text),
                                    bugun,
                                    OgretmenDurum.ogretmen_ad,
                                    widget.kitap.ad,
                                    widget.kitap.kitap_id);



                                var bilgi = HashMap<String, dynamic>();
                                bilgi["durum"] = "1";
                                refKitaplar.child(widget.kitap.kitap_id).update(bilgi);

                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 7),
                                  content: Text("Kitap Ödünç Verildi"),
                                ));
                                tfOgrenciAdSoyad.clear();
                                tfOkulNo.clear();
                                tfSure.clear();
                                secilenDeger = null;
                              });
                            } else {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Bilgileri Eksiksiz Doldurun !"),
                              ));
                            }


                          },
                          child: Text("Ver")),
                    ), //button
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
