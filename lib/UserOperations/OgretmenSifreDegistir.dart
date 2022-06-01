import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reservation/UserOperations/SifreGuncelle.dart';
import 'package:reservation/dbHelper/Ogretmenler.dart';

class OgretmenSifreDegisitir extends StatefulWidget {
  @override
  _OgretmenSifreDegisitirState createState() => _OgretmenSifreDegisitirState();
}

class _OgretmenSifreDegisitirState extends State<OgretmenSifreDegisitir> {
  @override
  // TODO: implement widget

  var refOgretmenler =
      FirebaseDatabase.instance.reference().child("ogretmenler");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Event>(
        stream: refOgretmenler.onValue,
        builder: (context, event) {
          if (event.hasData) {
            var ogretmenlerListesi = List<Ogretmenler>();


            var gelendegerler = event.data.snapshot.value;

            if (gelendegerler != null) {
              gelendegerler.forEach((key, nesne) {
                var gelenOgretmen = Ogretmenler.fromJson(key, nesne);
                ogretmenlerListesi.add(gelenOgretmen);

                //ogretmenlerlistesi isme göre sıralanıyor

                ogretmenlerListesi.sort((a, b) => a.ogretmen_ad.compareTo(b.ogretmen_ad));
              });
            }
            return ListView.builder(
              itemCount: ogretmenlerListesi.length,
              itemBuilder: (context, indeks) {
                String durum;
                var ogretmen = ogretmenlerListesi[indeks];

                //Gelen öğretmenrolü 1 ise texte yönetici yazdırılıyor
                // 2 ise texte öğretmen yazdırılıyor

                if (ogretmen.ogretmen_rol == 1) {
                  durum = "Yönetici";
                } else {
                  durum = "Öğretmen";
                }
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.15,
                  secondaryActions: [

                    IconSlideAction(
                      caption: "Güncelle",
                      color: Colors.teal,
                      icon: Icons.update,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SifreGuncelle(

                                  //Şifresi güncellenecek öğretmenin adı
                                  // ve id si Şifreguncelle sayfasına gönderiliyor

                                  ogretmen_id: ogretmen.ogretmen_id,
                                  ogretmen_ad: ogretmen.ogretmen_ad,
                                )));

                      },
                    ),
                    IconSlideAction(
                      caption: "Sil",
                      color: Colors.teal,
                      icon: Icons.delete,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Kayıt Sil"),
                                content: Text(
                                    "Bu Kullanıcıyı Silmek İstiyor musunuz ?"),
                                actions: [
                                  FlatButton(
                                    child: Text("Sil"),
                                    onPressed: () {

                                      refOgretmenler
                                          .child(ogretmen.ogretmen_id)
                                          .remove();
                                      Navigator.pop(context);

                                    },
                                  ),
                                  FlatButton(
                                    child: Text("İptal"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            });

                      },
                    ),
                  ],
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/8,
                    child: Card(

                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/2.6,
                              child: Text(
                                ogretmen.ogretmen_ad,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text(durum,style: TextStyle(fontSize: 12),),
                          ),


                        ],
                      ),
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
