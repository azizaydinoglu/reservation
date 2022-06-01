import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:collection';

import 'package:reservation/Kutuphane/Klass/Kategori.dart';

class KitapEkle extends StatefulWidget {
  @override
  _KitapEkleState createState() => _KitapEkleState();
}

class _KitapEkleState extends State<KitapEkle> {
  var secilenDeger;
  var refKategori =
  FirebaseDatabase.instance.reference().child("ayarlarkategori");

  var scaffoldKey=GlobalKey<ScaffoldState>();
  var refKitaplar = FirebaseDatabase.instance.reference().child("Kitap");

  Future<void> kitapKayit(int barkod_no, String ad, String yazar,
      String kategori, int sayfasayisi,) async {
    var bilgi = HashMap<String, dynamic>();

    bilgi["kitap_id"] = "";
    bilgi["barkod_no"] = barkod_no;
    bilgi["ad"] = ad;
    bilgi["yazar"] = yazar;
    bilgi["kategori"] = kategori;
    bilgi["sayfasayisi"] = sayfasayisi;
    bilgi["durum"] = "0";

    refKitaplar.push().set(bilgi);
  }

  String barcode = "";
  var tfbarcode = TextEditingController();
  var tfkitapAd = TextEditingController();
  var tfyazar = TextEditingController();
  var tfsayfasayi = TextEditingController();



  @override
  Widget build(BuildContext context) {
    var ekranGenisligi = MediaQuery.of(context).size.width;


    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.only(top: ekranGenisligi/12),
            child: SizedBox(
              width: ekranGenisligi/1.2,
              child: Card(
                elevation: 5,
                child: Column(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  children: [



                  Padding(
                      padding: EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfbarcode,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  barcodeScanning().then((String)=>setState((){
                                    tfbarcode.text = barcode;
                                  }));
                                },
                                child: Icon(Icons.qr_code_scanner)),
                            labelText: "barkod okutunuz",
                          ),
                        ),
                      ),
                    ),  //barkod no
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
                      padding:  EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi/2,
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

                                  kategorilerListesi.sort((a, b) => a.tur.compareTo(b.tur));


                                });
                              }
                              return SizedBox(
                                width: ekranGenisligi / 1.644,
                                height: MediaQuery.of(context).size.height/12,
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
                    ),// kategori

                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FlatButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          onPressed: () {
                            if(tfbarcode!=null && tfkitapAd!=null &&secilenDeger!=null ){
                              setState(() {

                                kitapKayit(int.parse(tfbarcode.text), tfkitapAd.text, tfyazar.text, secilenDeger, int.parse(tfsayfasayi.text));


                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 7),
                                  content: Text("Kayıt Yapıldı "),));
                                tfbarcode.clear();
                                tfkitapAd.clear();
                                tfyazar.clear();
                                secilenDeger=null;
                                tfsayfasayi.clear();

                              });




                            }
                            else{
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Bilgileri Eksiksiz Doldurun !"),));

                            }





                          },
                          child: Text("Ekle")),
                    ),//button
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future barcodeScanning() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Kamera izni alınamadı!';
        });
      } else {
        setState(() => this.barcode = 'Bilinmeyen Hata: $e');
      }
    } on FormatException {
      setState(() => this.barcode = 'Barkod Okutulamadı.');
    } catch (e) {
      setState(() => this.barcode = 'Bilinmeyen Hata: $e');
    }
  }


}
