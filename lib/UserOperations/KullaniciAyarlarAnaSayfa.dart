import 'package:flutter/material.dart';
import 'package:reservation/UserOperations/OgretmenEkle.dart';
import 'package:reservation/UserOperations/OgretmenSifreDegistir.dart';
import 'package:reservation/UserOperations/TumRezarvasyonlar.dart';

class KullaniciAyarlarAnaSayfa extends StatefulWidget {
  @override
  _KullaniciAyarlarAnaSayfaState createState() => _KullaniciAyarlarAnaSayfaState();
}

class _KullaniciAyarlarAnaSayfaState extends State<KullaniciAyarlarAnaSayfa> {
  int secilenIndeks = 0;

  var sayfaListesi = [TumRezarvasyonlar(), OgretmenEkle(),OgretmenSifreDegisitir()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: sayfaListesi[secilenIndeks],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline_sharp), label: "Rezarvasyonlar"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: "Ekle"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Ayarlar"),
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
