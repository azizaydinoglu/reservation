import 'dart:collection';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:reservation/Kutuphane/Klass/Kategori.dart';


class AyarlarKategori extends StatefulWidget {
  @override
  _AyarlarKategoriState createState() => _AyarlarKategoriState();
}

class _AyarlarKategoriState extends State<AyarlarKategori> {
  var secilenDeger;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refKategori =
      FirebaseDatabase.instance.reference().child("ayarlarkategori");
  var tfTur = TextEditingController();
  Future <void> kategoriSil(String tur) async{

    refKategori.onValue.listen((event) {
      var gelenDegerler=event.snapshot.value;
      if(gelenDegerler!=null){
        gelenDegerler.forEach((key,nesne){

          var gelenKategori=Kategori.fromJson(key, nesne);

          if(gelenKategori.tur==tur){

            refKategori.child(gelenKategori.id) .remove();

            secilenDeger=null;
          } else {return Center();}


        });

      }

    });
  }
  Future<void> kategoriKayit(String tur) async {
    var bilgi = HashMap<String, dynamic>();
    bilgi["id"] = "";
    bilgi["tur"] = tur;
    refKategori.push().set(bilgi);
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
                                  hint: Text("Seçiniz",style: TextStyle(fontSize: 15),),
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: ekranGenisligi / 2,
                        child: TextField(
                          controller: tfTur,
                          decoration: InputDecoration(
                            labelText: "kategori adı giriniz",
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
                                if (tfTur.text != "") {

                                  kategoriKayit(tfTur.text);
                                  setState(() {

                                    scaffoldKey.currentState.showSnackBar(SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text("Kategori Oluşturuldu "),

                                    ));
                                    tfTur.clear();

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



                                  kategoriSil(secilenDeger);
                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Kategori Silindi "),

                                  ));
                                } else {

                                  scaffoldKey.currentState.showSnackBar(SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Kategori Seçiniz "),

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
