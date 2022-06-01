import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation/Rezarvasyon/MyReservations.dart';
import 'package:reservation/Rezarvasyon/TarihSec.dart';
import 'package:reservation/dbHelper/Rezervasyon.dart';

class RezarvasyonAnaSayfa extends StatefulWidget {
  @override
  _AnaSayfaState createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<RezarvasyonAnaSayfa> {
  var refRezervasyon =
      FirebaseDatabase.instance.reference().child("Rezervasyon");

 /* Future<void> rezervasyonTemizle() async {
    refRezervasyon.onValue.listen((event) {
      var gelenRezervasyonlar = event.snapshot.value;

      if (gelenRezervasyonlar != null) {
        gelenRezervasyonlar.forEach((key, nesne) {
          var gelenRezervasyon = Rezervasyon.fromJson(key, nesne);

          String tarih = gelenRezervasyon.tarih;
          var formatlanmistarih = DateFormat("dd/MM/yyyy").parse(tarih);

          Duration fark = DateTime.now().difference(formatlanmistarih);
          var kalanSure = fark.inDays;

          if (kalanSure > 0) {
            refRezervasyon
                .reference()
                .child(gelenRezervasyon.rezervasyon_id)
                .remove();
          } else {}
        });

        if (this.mounted) {
          setState(() {});
        }
      }
    });
  }*/

  int secilenIndeks = 0;

  // BottomNavigationBarın sayfa listesi

  var sayfaListesi = [MyReservations(), TarihSec()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  rezervasyonTemizle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sayfaListesi[secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_sharp), label: "Rezervasyonlarım"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: "Yeni Rezervasyon"),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.black,
        currentIndex: secilenIndeks,
        onTap: (index) {
          setState(() {
            secilenIndeks = index;
          });
        },
      ),
    );
  }
}
