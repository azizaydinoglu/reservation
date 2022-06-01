import 'package:flutter/material.dart';
import 'package:reservation/Kutuphane/Screens/Ayarlar/AyarlarKategori.dart';
import 'package:reservation/Kutuphane/Screens/Ayarlar/AyarlarSinif.dart';

class Ayarlar extends StatefulWidget {
  @override
  _AyarlarState createState() => _AyarlarState();
}

class _AyarlarState extends State<Ayarlar> {


  int secilenIndeks = 0;

  // BottomNavigationBarın sayfa listesi

  var sayfaListesi = [AyarlarKategori(), AyarlarSinif()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:sayfaListesi[secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "Kategoriler"),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: "Sınıflar"),
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
