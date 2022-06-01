
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:reservation/Kutuphane/Klass/KitapFirebase.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/KitapDetay.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/KitapGuncelle.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/OduncVer.dart';

class Kitaplar extends StatefulWidget {
  @override
  _KitaplarState createState() => _KitaplarState();
}

class _KitaplarState extends State<Kitaplar> {

  var tfanim=TextEditingController();
  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var refKitaplar = FirebaseDatabase.instance.reference().child("Kitap");

  @override
  Widget build(BuildContext context) {

    var ekranGenisligi = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
     appBar: AppBar(
        title: aramaYapiliyorMu
            ? TextField(
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
                decoration: InputDecoration(

                    hintText: "kitap adı",
                    hintStyle: TextStyle(

                      color: Colors.white,fontSize: 15
                    )),
                onChanged: (aramaSonucu) {
                  setState(() {
                    aramaKelimesi = aramaSonucu;
                  });
                },
              )
            : Align(alignment: Alignment.center,
            child: Text("kitap ara",style: TextStyle(color: Colors.white,fontSize: 15),)),
        actions: [
          aramaYapiliyorMu
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = false;
                      aramaKelimesi = "";
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      aramaYapiliyorMu = true;
                    });
                  },
                ),
        ],
      ),
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder<Event>(
              stream: refKitaplar.onValue,
              builder: (context, event) {
                if (event.hasData) {
                  int kitapsayisi = 0;
                  var kitaplarListesi = List<KitapFirebase>();
                  var gelenkitaplar = event.data.snapshot.value;
                  if (gelenkitaplar != null) {
                    gelenkitaplar.forEach((key, nesne) {
                      var gelenKitap = KitapFirebase.fromJson(key, nesne);

                      if (aramaYapiliyorMu) {
                        if (gelenKitap.ad.contains(aramaKelimesi)) {
                          kitaplarListesi.add(gelenKitap);
                        }
                      } else {
                        kitaplarListesi.add(gelenKitap);
                      }

                      //Kitaplar ada göre sıralanıyor

                      kitaplarListesi.sort((a, b) => a.ad.compareTo(b.ad));
                    });
                  }
                  return ListView.builder(
                    itemCount: kitaplarListesi.length,
                    itemBuilder: (context, indeks) {
                      String kitapNerede;
                      bool boya;
                      kitapsayisi++;
                      var kitap = kitaplarListesi[indeks];

                      if (kitap.durum == "0") {
                        boya = true;
                        kitapNerede = "Rafta";
                      } else {
                        kitapNerede = "Okuyucuda";
                        boya = false;
                      }
                      return Slidable(
                        enabled: boya,
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        secondaryActions: [
                          IconSlideAction(


                            caption: "Ödünç Ver",


                            color: Colors.teal,
                            icon: Icons.wifi_protected_setup,
                            onTap: () {

                             Navigator.push(context, MaterialPageRoute(builder: (context)=>OduncVer(kitap: kitap,)));
                            },
                          ),
                          IconSlideAction(
                          caption: "Güncelle",
                          color: Colors.teal,
                          icon: Icons.update,
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>KitapGuncelle(kitap:kitap)));
                          },
                        ),
                          IconSlideAction(
                            caption: "Sil",
                            color: Colors.teal,
                            icon: Icons.delete,
                            onTap: () {
                              scaffoldKey.currentState.showSnackBar(SnackBar(
                                duration: Duration(seconds: 3),
                                content: Text("${kitap.ad} silindi"),
                              ));


                              refKitaplar.reference().child(kitap.kitap_id).remove();


                            },
                          ),]

                        ,

                        child: Card(
                          // elevation: 5,
                          child: ListTile(
                            trailing: Text(
                              kitapNerede,
                              style:
                                  TextStyle(color: boya ? Colors.green : Colors.red),
                            ),
                            leading: Text("$kitapsayisi"),
                            title: Text(kitap.ad),
                            subtitle: Text(kitap.yazar),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>KitapDetay(kitap:kitap)));
                            },
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
          ),
        ],
      ),
    );
  }
}
