import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class SifreGuncelle extends StatefulWidget {
  String ogretmen_id;
  String ogretmen_ad;

  //Sifre değiştir sayfasından gelen öğretmen ad ve id
  //öğretmen ad ekranda göstermek için alındı
  //önemli olan id

  SifreGuncelle({this.ogretmen_id, this.ogretmen_ad});

  @override
  _SifreGuncelleState createState() => _SifreGuncelleState();
}

class _SifreGuncelleState extends State<SifreGuncelle> {
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var sifreController = TextEditingController();
  var sifreController2 = TextEditingController();

  var refOgretmenler =
  FirebaseDatabase.instance.reference().child("ogretmenler");

  //ID ye göre şifre güncelleniyor.

  Future<void> guncelle(ogretmen_id ,String ogretmen_sifre) async {
    var bilgi = HashMap<String, dynamic>();

    bilgi["ogretmen_id"] = ogretmen_id;
   // bilgi["ogretmen_sifre"] = ogretmen_sifre;
    bilgi["ogretmen_sifre"] =  md5.convert(utf8.encode(ogretmen_sifre)).toString();


    refOgretmenler.child(ogretmen_id).update(bilgi);

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Şifre Güncelle"),),
      key:scaffoldKey ,
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
                    width: MediaQuery.of(context).size.width/2,
                      child: Align(
                        alignment: Alignment.center,

                          child: Text(widget.ogretmen_ad,style: TextStyle(fontSize: MediaQuery.of(context).size.width/22,color: Colors.teal,fontWeight: FontWeight.bold),))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(

                    width: MediaQuery.of(context).size.width/2,
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
                    width: MediaQuery.of(context).size.width/2,
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

                          //Güncelleme fonksiyonu

                            guncelle(widget.ogretmen_id, sifreController.text);
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              duration: Duration(seconds: 5),
                              content: Text("Güncellendi "),));




                        } else {
                          scaffoldKey.currentState.showSnackBar(SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text("Hatalı Bilgi ! "),));


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
