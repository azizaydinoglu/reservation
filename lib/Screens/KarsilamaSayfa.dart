import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_particles/particles.dart';
import 'package:intl/intl.dart';
import 'package:reservation/Kutuphane/Klass/Odunc.dart';
import 'package:reservation/OgretmenDurum.dart';

class KarsilamaSayfa extends StatefulWidget {
  @override
  _KarsilamaSayfaState createState() => _KarsilamaSayfaState();
}

class _KarsilamaSayfaState extends State<KarsilamaSayfa> {
  var kitapListesi = List<String>();
  bool hatirla = false;
  int sure = 0;

  var refRapor = FirebaseDatabase.instance.reference().child("odunc");

  Future<void> hatirlat() async {
    refRapor.onValue.listen((event) {
      var gelenOduncler = event.snapshot.value;

      if (gelenOduncler != null) {
        gelenOduncler.forEach((key, nesne) {
          var gelenOdunc = Odunc.fromJson(key, nesne);

          String tarih = gelenOdunc.tarih;
          var formatlanmistarih = DateFormat("dd/MM/yyyy").parse(tarih);
          int sure = gelenOdunc.odunc_sure;
          var iadeTarihi = formatlanmistarih.add(Duration(days: sure));
          // String formatlanmisIadeTarihi=DateFormat("dd/MM/yyyy").format(iadeTarihi);

          Duration fark = iadeTarihi.difference(DateTime.now());
          var kalanSure = fark.inDays;

          if (OgretmenDurum.ogretmen_ad == gelenOdunc.ogretmen_ad &&
              kalanSure + 1 < 0) {
            kitapListesi.add(gelenOdunc.kitap_ad);

            hatirla = true;
            return;
          } else {
            hatirla = false;
            return;
          }
        });

        if (this.mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hatirlat();
  }

  @override
  Widget build(BuildContext context) {
    var ekranYuksekligi = MediaQuery.of(context).size.height;
    var ekranGenisligi = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Particles(30, Colors.blueGrey.shade100),
          ),
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  "Hoşgeldiniz,\n",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: ekranYuksekligi / 10),
                  child: Text(
                    "${OgretmenDurum.ogretmen_ad}",
                    style: TextStyle(fontSize: ekranGenisligi/10, color: Colors.teal,fontWeight: FontWeight.bold),
                  ),
                ),
                Visibility(
                    visible: hatirla,
                    child: Text(
                      "İade almanız gereken kitap vardır\n",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
                Visibility(
                    visible: hatirla,
                    child: Text(
                      "$kitapListesi",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )),
              ])),
        ],
      ),
    );
  }
}
