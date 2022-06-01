import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reservation/OgretmenDurum.dart';
import 'package:reservation/dbHelper/Rezervasyon.dart';

class MyReservations extends StatefulWidget {
  @override
  _MyReservationsState createState() => _MyReservationsState();
}

class _MyReservationsState extends State<MyReservations> {
  var refRezervasyon =
      FirebaseDatabase.instance.reference().child("Rezervasyon");

  @override
  void initState() {
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Event>(
        stream: refRezervasyon.onValue,
        builder: (context, event) {
          if (event.hasData) {
            var rezervasyonlarListesi = List<Rezervasyon>();

            var gelendegerler = event.data.snapshot.value;

            if (gelendegerler != null) {
              gelendegerler.forEach((key, nesne) {
                var gelenRezervasyon = Rezervasyon.fromJson(key, nesne);
                if (gelenRezervasyon.ogretmen_ad == OgretmenDurum.ogretmen_ad) {
                  rezervasyonlarListesi.add(gelenRezervasyon);

                    //Rezervasyonlar Listesi tarihe göre sıralanıyor

                  rezervasyonlarListesi.sort((a, b) => a.tarih.compareTo(b.tarih));
                }
              });
            }
            return ListView.builder(
              itemCount: rezervasyonlarListesi.length,
              itemBuilder: (context, indeks) {
                var rezervasyon = rezervasyonlarListesi[indeks];

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                    secondaryActions: [

                      IconSlideAction(
                        caption: "Sil",
                        color: Colors.teal,
                        icon: Icons.delete,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Rezervasyon Sil"),
                                  content: Text(
                                      "Bu Rezervasyonu Silmek İstiyor musunuz ?"),
                                  actions: [
                                    FlatButton(
                                      child: Text("Sil"),
                                      onPressed: () {

                                        //Rezervasyon Siliniyor
                                        refRezervasyon
                                            .reference()
                                            .child(rezervasyon.rezervasyon_id)
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
                      ),],
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height/8,
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/3,
                              child: Text(
                                rezervasyon.ogretmen_ad,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text(
                                rezervasyon.tarih,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding:  EdgeInsets.only(right: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/4,
                              child: Text(
                                rezervasyon.saat,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
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
