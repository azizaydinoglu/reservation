import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
class OgretmenEkle extends StatefulWidget {
  @override
  _OgretmenEkleState createState() => _OgretmenEkleState();
}

class _OgretmenEkleState extends State<OgretmenEkle> {
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var rolDurum;

  var adController = TextEditingController();
  var sifreController = TextEditingController();
  var refOgretmenler =
      FirebaseDatabase.instance.reference().child("ogretmenler");

  Future<void> kayit(String ogretmen_ad, String ogretmen_sifre, int ogretmen_rol) async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["ogretmen_id"] = "";
    bilgi["ogretmen_ad"] = ogretmen_ad;
    bilgi["ogretmen_sifre"] = ogretmen_sifre;
    bilgi["ogretmen_rol"] = ogretmen_rol;
    refOgretmenler.push().set(bilgi);
  }

  @override
  Widget build(BuildContext context) {
    var ekranGenisligi = MediaQuery.of(context).size.width;
    var ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.only(top: ekranYuksekligi/12),
            child: SizedBox(
              width: ekranGenisligi/1.2,
              child: Card(
                elevation: 5,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [


                    Padding(
                      padding:  EdgeInsets.only(left: 8,right: 8,bottom:8, top:MediaQuery.of(context).size.height/10),
                      child: SizedBox(
                        width: ekranGenisligi/2,
                        child: TextField(
                          controller: adController,
                          decoration: InputDecoration(
                            labelText: "ad soyad giriniz",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi/2,
                        child: TextField(
                          controller: sifreController,
                          decoration: InputDecoration(
                            labelText: "şifre giriniz",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: ekranGenisligi/2,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height/12,
                            child: DropdownButton(

                              underline: Container(
                                height: 1,
                                color: Colors.teal,
                              ),
                              icon: Padding(
                                padding: EdgeInsets.only(left: ekranGenisligi / 25),
                                child: Icon(Icons.arrow_drop_down, color: Colors.teal),
                              ),
                              value: rolDurum,

                              // rol 1 ise idareci
                              //rol 2 ise yönetici yapılıyor
                              hint: Text("Öğretmen / Yönetici",style: TextStyle(fontSize: 15),),
                              items: [
                                DropdownMenuItem(
                                  child: Text("Öğretmen"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                  child: Text("Yönetici"),
                                  value: 1,
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {

                                  // doğrudan rolDurum value olarak
                                  // firebase kayıt yapılıyor

                                  rolDurum = value;

                                });
                              },
                            ),
                          )),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(left: 8,right:8,top: 8,bottom: ekranYuksekligi/10),
                      child: FlatButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          onPressed: () {
                            if(adController!=null && sifreController!=null && rolDurum!=null){
                              setState(() {


                                kayit(adController.text, sifreController.text,rolDurum);

                                scaffoldKey.currentState.showSnackBar(SnackBar(
                                  duration: Duration(seconds: 7),
                                  content: Text("${adController.text} kayıt edildi "),));
                                adController.clear();
                                sifreController.clear();
                                rolDurum=null;
                              });




                            }
                            else{
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("Bilgileri Eksiksiz Doldurun !"),));

                            }

                          },
                          child: Text("Ekle")),
                    ),
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
