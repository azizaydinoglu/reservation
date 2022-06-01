import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reservation/OgretmenDurum.dart';
import 'package:reservation/dbHelper/Rezervasyon.dart';

class TarihSec extends StatefulWidget {
  @override
  _TarihSecState createState() => _TarihSecState();
}

class _TarihSecState extends State<TarihSec> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  //Tarih Seç butonuna tıklandıktan sonra grid gösterilecek

  bool gridGoster = false;
  var tfTarih = TextEditingController();

  //Firebaseden dolu gelen randevulara bakılmaksızın Tüm Gride saatler eklenecek

  var saat = [
    "08:00-09:00",
    "09:00-10:00",
    "10:00-11:00",
    "11:00-12:00",
    "12:00-13:00",
    "13:00-14:00",
    "14:00-15:00",
    "15:00-16:00",
    "16:00-17:00"
  ];

  //Tarih TextFieldı boş olup tıklanmaya çalışırsa kırmızı uyarı verecek

  bool texthindurum = true;

  //saatlerin müsait lma durumu true müsait olmama durumu false
  var durum = [true, true, true, true, true, true, true, true, true];

  var refRezervasyon =
      FirebaseDatabase.instance.reference().child("Rezervasyon");

  //Program ilk bu fonksiyondan başlıyor. Tarih Seç butonuna basıldığında
  // müsait olmayan saatler durum listten false yapılıyor. Müsaitse dokunulmuyor


  void rezervasyonAra() {
    //değişim dinlemeli
    refRezervasyon.onValue.listen((event) {
      var gelenRezervasyonlar = event.snapshot.value;
      if (gelenRezervasyonlar != null) {
        gelenRezervasyonlar.forEach((key, nesne) {
          var gelenRezervasyon = Rezervasyon.fromJson(key, nesne);

          if (gelenRezervasyon.tarih == tfTarih.text) {

            //Firebasede önce ilgili tarihe gidiliyor
            // sonra tek tek saatlere bakılıyor

            for (int a = 0; a < saat.length; a++) {
              if (gelenRezervasyon.saat == saat[a]) {

                //böyle bir saatte kayıt var
                //Gridi pasifleştir

                durum[a] = false;


              } else {

              }
            }
          }
        });
        // İşlem bittikten sonra setstate çalıştırılıyor. Kullanılması
        // pek tavsiye edilmiyor

        if (this.mounted) {
          setState(() {
            gridGoster = true;
          });
        }

      }else {
        setState(() {
          gridGoster=true;
        });


        print("hepsi silinmiş");
      }
      // hepsi silindiği için açılmıyor


    });
  }
        //Rezervasyon ara fonksiyonundan uygun olan ve olmayan saatler
        // listelendikten sonra Gridden rezervasyon kayıt çalıştırılır.

  Future<void> rezervasyonKayit(
      String ogretmen_ad, String saat, String tarih) async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["ogretmen_id"] = "";
    bilgi["ogretmen_ad"] = ogretmen_ad;
    bilgi["saat"] = saat;
    bilgi["tarih"] = tarih;
    refRezervasyon.push().set(bilgi);
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    var ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: EdgeInsets.all(ekranGenisligi / 51.375),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: ekranGenisligi / 50),
              child: Row(

                children: [
                  Spacer(
                    flex: 10,
                  ),
                  SizedBox(
                    width: ekranGenisligi / 2.5,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: ekranGenisligi / 25),
                      controller: tfTarih,
                      decoration: InputDecoration(
                          hintText: "Tarih giriniz",
                          hintStyle: texthindurum
                              ? TextStyle(color: Colors.black87)
                              : TextStyle(color: Colors.red)),
                      onTap: () {

                        // Text Fieldda tarih açılıyor

                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2021),
                          lastDate: DateTime(2022),
                        ).then((alinanTarih) {
                          setState(() {


                            tfTarih.text =
                                "${alinanTarih.day}/${alinanTarih.month}/${alinanTarih.year}";

                            // Her Tarih seçildikten sonra  grid kapatılıyor
                            //Durum listesi true yapılırak bütün saatler
                            // Müsait yapılıyor. Tarih seç butonuna tekrar
                            // basıldığında rezervasyonAra fonksiyonu
                            // çağrıldığında tekrar ilgili tarihte varsa false
                            // olacak

                            gridGoster = false;

                            texthindurum = true;

                            durum = [
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true
                            ];
                          });
                        });
                      },
                    ),
                  ),
                  Spacer(flex: 80),
                  SizedBox(
                    width: ekranGenisligi / 4,
                    height: ekranGenisligi / 10,
                    child: FlatButton(
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2)),
                      child: Container(
                        child: Text(
                          "Seç",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: ekranGenisligi / 25),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (tfTarih.text == "") {

                            //Tarih Alanı boş ise texhint durum false olur.
                            // Yani kırmızı renkte tarih giriniz yazar

                            texthindurum = false;
                          } else {

                            //Tarihseç butonu tıklanınca rezervasyonAra
                            // fonksiyonu çağrılır.
                            rezervasyonAra();
                          }
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 10,
                  )
                ],
              ),
            ),
            Divider(
              height: 30,
            ),
            Expanded(
              child: Visibility(
                visible: gridGoster,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 2 / 1),
                    itemCount: saat.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Center(
                          child: ListTile(

                            //Griddeki ListTilelar durum listesine göre true
                            // yada false olur.

                            enabled: durum[index],
                            trailing: Icon(Icons.more_vert),
                            title: Padding(
                              padding: EdgeInsets.only(
                                  bottom: ekranGenisligi / 82.2),
                              child: Text(
                                saat[index],
                                style: TextStyle(
                                  fontSize: ekranGenisligi / 22.83,
                                ),
                              ),
                            ),

                            // durum listesine göre  true ise Müsait yazar
                            //false ise dolu yazar
                            subtitle: durum[index]
                                ? Text(
                                    "Müsait",
                                    style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text(
                                    "Dolu",
                                    style: TextStyle(color: Colors.red),
                                  ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext contect) {
                                    return AlertDialog(
                                      title: Text(
                                        saat[index],
                                      ),
                                      content:
                                          Text("Onaylamak İstiyor musunuz ?"),
                                      actions: [
                                        FlatButton(
                                          child: Text("Evet"),
                                          onPressed: () {

                                            // rezervasyonkayıt burada yapılıyor.
                                            // Gridin içindeyiz

                                            rezervasyonKayit(
                                                OgretmenDurum.ogretmen_ad,
                                                saat[index],
                                                tfTarih.text);

                                            //ilgili durum index kapatılır

                                            setState(() {
                                              durum[index] = false;

                                              Navigator.pop(context);
                                            });



                                            scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 7),
                                                    content: Text(
                                                  "Reservasyon Tarihi:   ${tfTarih.text}  /  ${saat[index]} "),
                                            ));
                                          },
                                        ),
                                        FlatButton(
                                          child: Text("Hayır"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
