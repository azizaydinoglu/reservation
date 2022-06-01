import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/KitapEkle.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/Kitaplar.dart';

class Kitap extends StatefulWidget {
  @override
  _KitapState createState() => _KitapState();
}

class _KitapState extends State<Kitap> {

  int secilenIndeks = 0;

  // BottomNavigationBarın sayfa listesi

  var sayfaListesi = [KitapEkle(), Kitaplar()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: sayfaListesi[secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Ekle"),
          BottomNavigationBarItem(icon: FaIcon(FontAwesomeIcons.book,size: 20,), label: "Kitaplar"),
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
