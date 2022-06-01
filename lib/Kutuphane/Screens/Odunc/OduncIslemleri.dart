import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:reservation/Kutuphane/Klass/Odunc.dart';
import 'package:reservation/Kutuphane/Screens/Odunc/OduncDetay.dart';

class OduncIslemleri extends StatefulWidget {
  @override
  _OduncIslemleriState createState() => _OduncIslemleriState();
}

class _OduncIslemleriState extends State<OduncIslemleri> {
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refKitaplar = FirebaseDatabase.instance.reference().child("Kitap");
  var refOdunc = FirebaseDatabase.instance.reference().child("odunc");
  var refRaporlar = FirebaseDatabase.instance.reference().child("rapor");

  Future<void> raporKayit(
    String ogrenci_ad,
    int okul_no,
    String sinif,
    String kitap_ad,
    String ogretmen_ad,
  ) async {
    var bilgi = HashMap<String, dynamic>();

    bilgi["rapor_id"] = "";
    bilgi["ogrenci_ad"] = ogrenci_ad;
    bilgi["okul_no"] = okul_no;
    bilgi["sinif"] = sinif;
    bilgi["kitap_ad"] = kitap_ad;
    bilgi["ogretmen_ad"] = ogretmen_ad;

    refRaporlar.push().set(bilgi);
  }

  @override
  Widget build(BuildContext context) {

    var ekranGenisligi = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "aramak istediğiniz kitap",
                    hintStyle: TextStyle(
                      color: Colors.white,fontSize: 15
                    )),
                onChanged: (aramaSonucu) {
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : Align(
                alignment: Alignment.center,
                child: Text(
                  "ödünç ara",style: (TextStyle(fontSize: 15)),
                )),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                ),
        ],
      ),
      body: StreamBuilder<Event>(
        stream: refOdunc.onValue,
        builder: (context, event) {
          if (event.hasData) {
            int oduncSayisi = 0;
            var odunclerListesi = List<Odunc>();
            var gelenOduncler = event.data.snapshot.value;
            if (gelenOduncler != null) {
              gelenOduncler.forEach((key, nesne) {
                var gelenOdunc = Odunc.fromJson(key, nesne);

                if (aramaYapiliyorMu) {
                  if (gelenOdunc.kitap_ad.contains(aramaKelimesi)) {
                    odunclerListesi.add(gelenOdunc);
                  }
                } else {
                  odunclerListesi.add(gelenOdunc);
                }

                //Kitaplar ada göre sıralanıyor

                odunclerListesi
                    .sort((a, b) => a.kitap_ad.compareTo(b.kitap_ad));
              });
            }
            return ListView.builder(
              itemCount: odunclerListesi.length,
              itemBuilder: (context, indeks) {

                oduncSayisi++;
                var odunc = odunclerListesi[indeks];

                String tarih = odunc.tarih;
                var formatlanmistarih = DateFormat("dd/MM/yyyy").parse(tarih);
                int sure = odunc.odunc_sure;
                var iadeTarihi = formatlanmistarih.add(Duration(days: sure));
                // String formatlanmisIadeTarihi=DateFormat("dd/MM/yyyy").format(iadeTarihi);

                Duration fark = iadeTarihi.difference(DateTime.now());
                var kalanSure = fark.inDays;

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: [
                    IconSlideAction(
                      caption: "İade Al",
                      color: Colors.teal,
                      icon: Icons.undo,
                      onTap: () {


                        //metod burada olacak
                        //silme işlemi, durum değiştirme, rapor koleksiyonuna ekleme olacak

                        var bilgi = HashMap<String, dynamic>();
                        bilgi["durum"] = "0";
                        refKitaplar.child(odunc.kitap_id).update(bilgi);

                        raporKayit(odunc.ogrenci_ad, odunc.okul_no, odunc.sinif,
                            odunc.kitap_ad, odunc.ogretmen_ad);

                        refOdunc.reference().child(odunc.odunc_id).remove();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text("İade Alındı"),
                        ));
                      },
                    ),
                  ],
                  child: Card(
                    // elevation: 5,
                    child: ListTile(
                      trailing: Text(
                        "Kalan Süre: ${kalanSure+1}",
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Text("$oduncSayisi"),
                      title: Text(
                        odunc.kitap_ad,
                      ),
                      subtitle: Text(odunc.ogrenci_ad),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OduncDetay(odunc: odunc)));
                      },
                    ),
                  ),
                );
              },
            );
          } else {
            return Center();
          }
        },
      ),
    );
  }
}
