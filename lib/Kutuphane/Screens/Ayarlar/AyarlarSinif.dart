import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reservation/Kutuphane/Klass/Sinif.dart';

class AyarlarSinif extends StatefulWidget {
  @override
  _AyarlarSinifState createState() => _AyarlarSinifState();
}

class _AyarlarSinifState extends State<AyarlarSinif> {

  var secilenDeger;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refSinif =
  FirebaseDatabase.instance.reference().child("sinif");
  var tfSinif = TextEditingController();
  Future <void> sinifSil(String sinif) async{

    refSinif.onValue.listen((event) {
      var gelenDegerler=event.snapshot.value;
      if(gelenDegerler!=null){
        gelenDegerler.forEach((key,nesne){

          var gelenSinif=Sinif.fromJson(key, nesne);

          if(gelenSinif.sinif==sinif){

            refSinif.child(gelenSinif.id) .remove();

            secilenDeger=null;
          } else {return Center();}


        });

      }

    });
  }

  Future<void> sinifKayit(String sinif) async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["id"] = "";
    bilgi["sinif"] = sinif;
    refSinif.push().set(bilgi);
  }


  @override
  Widget build(BuildContext context) {
    var ekranGenisligi = MediaQuery.of(context).size.width;
    var ekranYuksekligi = MediaQuery.of(context).size.width;
    return Scaffold(
      key:scaffoldKey,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:  EdgeInsets.only(top: ekranYuksekligi/4),
            child: SizedBox(
              width: ekranGenisligi/1.2,
              child: Card(
                elevation: 5,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(top: ekranYuksekligi/7),
                      child: SizedBox(
                        width: ekranGenisligi/2,
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

                                  siniflarListesi.sort((a, b) => a.sinif.compareTo(b.sinif));



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
                                  hint: Text("Seçiniz",style: TextStyle(fontSize: 15),),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfSinif,
                          decoration: InputDecoration(
                            labelText: "sınıf adı giriniz",
                              labelStyle: TextStyle(fontSize: 15)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: ekranGenisligi/2,
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                  color: Colors.teal,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (tfSinif.text != "") {

                                      sinifKayit(tfSinif.text);
                                      setState(() {

                                        scaffoldKey.currentState.showSnackBar(SnackBar(
                                          duration: Duration(seconds: 5),
                                          content: Text("Sınıf Oluşturuldu "),

                                        ));
                                        tfSinif.clear();

                                      }

                                      );

                                    } else {
                                      scaffoldKey.currentState.showSnackBar(SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text("Bilgileri Eksiksiz Doldurun !"),
                                      ));
                                    }
                                  },
                                  child: Text("Ekle")), //Ekle
                              Spacer(),
                              FlatButton(
                                color: Colors.teal,
                                textColor: Colors.white,

                                child: Text("Sil"),
                                onPressed: (){

                                  if(secilenDeger!=null){

                                    sinifSil(secilenDeger);
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Sınıf Silindi "),

                                    ));


                                  } else {
                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Sınıf Seçiniz "),

                                    ));
                                  }





                                },
                              ), //Sil

                            ],),
                        )
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
