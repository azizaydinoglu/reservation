import 'dart:collection';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reservation/OgretmenDurum.dart';
import 'package:reservation/dbHelper/Ogretmenler.dart';

class SifreDegistir extends StatefulWidget {
  @override
  _SifreDegistirState createState() => _SifreDegistirState();
}

class _SifreDegistirState extends State<SifreDegistir> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var sifreController = TextEditingController();
  var sifreController2 = TextEditingController();

  var refOgretmenler =
      FirebaseDatabase.instance.reference().child("ogretmenler");


  Future<void> guncelle() async {
    refOgretmenler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value;
      if (gelenDegerler != null) {
        gelenDegerler.forEach((key, nesne) {
          var gelenOgretmen = Ogretmenler.fromJson(key, nesne);

          //Staticteki öğretmenadı ile firebasede eşleşen öğretmen adına ait şifre güncelleniyor

          if (OgretmenDurum.ogretmen_ad == gelenOgretmen.ogretmen_ad) {
            var bilgi = HashMap<String, dynamic>();
           // bilgi["ogretmen_sifre"] = sifreController.text;
            bilgi["ogretmen_sifre"] = md5.convert(utf8.encode(sifreController.text)).toString();
            refOgretmenler.child(gelenOgretmen.ogretmen_id).update(bilgi);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width/1.3,
          height:MediaQuery.of(context).size.height/1.7 ,
          child: Card(
            elevation: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            OgretmenDurum.ogretmen_ad,
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width / 22,
                                color: Colors.teal,
                                fontWeight: FontWeight.bold),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: sifreController,
                      decoration: InputDecoration(
                        labelText: "yeni şifre",

                        labelStyle: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: sifreController2,
                      decoration: InputDecoration(
                        labelText: "şifre tekrarı",
                          labelStyle: TextStyle(fontSize: 15)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                      color: Colors.teal,
                      textColor: Colors.white,
                      onPressed: () {
                        if (sifreController.text == sifreController2.text &&
                            sifreController.text != "" &&
                            sifreController2.text != "") {
                          guncelle();

                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text("Güncellendi "),
                          ));
                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text("Hatalı Bilgi ! "),
                          ));
                        }
                      },
                      child: Text("Güncelle")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
