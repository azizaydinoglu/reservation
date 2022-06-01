import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reservation/OgretmenDurum.dart';
import 'package:reservation/Screens/AnaSayfa.dart';
import 'package:reservation/dbHelper/Ogretmenler.dart';
import 'package:reservation/localDb/VeriTabaniYardimcisi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Takvim Türkçeleştiriliyor

      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: [const Locale('tr')],
      debugShowCheckedModeBanner: false,
      title: "Reservasyon",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        //TextFieldların altına çizgi ekleniyor
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var controllerSifre = TextEditingController();
  var refOgretmenler =
      FirebaseDatabase.instance.reference().child("ogretmenler");

  Future<void> sifreGir() async {
    refOgretmenler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value;
      if (gelenDegerler != null) {
        gelenDegerler.forEach((key, nesne) {
          var gelenOgretmen = Ogretmenler.fromJson(key, nesne);

          if (secilenDeger == gelenOgretmen.ogretmen_ad) {
            //Öğretmen Ad ve Öğretmen rol static e aktarılıyor

            OgretmenDurum.ogretmen_ad = secilenDeger;
            OgretmenDurum.ogretmen_rol = gelenOgretmen.ogretmen_rol;
            if (gelenOgretmen.ogretmen_sifre.toString() == md5.convert(utf8.encode(controllerSifre.text)).toString()
                ) {


              //Şifre doğru girildiyse locale sqflite oluşturulup giriş durumu bir yapılıyor
              // boş bir öğretmen rol atanıyor
              // Screens paketindeki  Drawer Anasayfaya geçiş yapılıyor
              localEkle(secilenDeger, 1, OgretmenDurum.ogretmen_rol);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Anasayfa(
                            ogretmen_ad: gelenOgretmen.ogretmen_ad,
                          )));
            } else {
              scaffoldKey.currentState.showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                content: Text("Hatalı Şifre"),
              ));
            }
          }
        });
      } else {
        return Text("Hata var");
      }
    });
  }

  Future<void> localEkle(
      String ogretmen_ad, int giris_durum, int ogretmen_rol) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("oturum");
    var bilgiler = Map<String, dynamic>();
    bilgiler["ogretmen_ad"] = ogretmen_ad;
    bilgiler["giris_durum"] = giris_durum;
    bilgiler["ogretmen_rol"] = ogretmen_rol;

    await db.insert("oturum", bilgiler);
  }

  var secilenDeger;
  bool goster = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Program ilk buradan başlıyor
    //İlk girişte locale bakılıyor giriş durumu 1 ise AnaSayfaya geçiş yapılıyor
    //Giriş Durumu 0 sa LoginPAge de şifre isteniyor

    Future(() async {
      var db = await VeritabaniYardimcisi.veritabaniErisim();
      List<Map<String, dynamic>> maps = await db
          .rawQuery("SELECT count(*) AS sonuc FROM oturum WHERE giris_durum=1");
      if (maps[0]["sonuc"] == 1) {
        var db = await VeritabaniYardimcisi.veritabaniErisim();
        List<Map<String, dynamic>> maps =
            await db.rawQuery("SELECT ogretmen_ad,ogretmen_rol from oturum");
        var ad = maps[0]["ogretmen_ad"];
        var rol = maps[0]["ogretmen_rol"];

        OgretmenDurum.ogretmen_rol = rol;

        OgretmenDurum.ogretmen_ad = ad;

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Anasayfa(ogretmen_ad: OgretmenDurum.ogretmen_ad)));
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
 

  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    var ekranGenisligi = ekranBilgisi.size.width;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Kullanıcı Girişi"),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: ekranGenisligi / 12, bottom: ekranGenisligi / 20.55),
              child: Icon(
                Icons.account_circle_outlined,
                size: ekranGenisligi / 2.055,
                color: Colors.teal,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ekranGenisligi / 51.375),
              child: StreamBuilder<Event>(
                stream: refOgretmenler.onValue,
                builder: (context, event) {
                  if (event.hasData) {
                    var ogretmenlerListesi = List<Ogretmenler>();

                    var gelenDegerler = event.data.snapshot.value;
                    if (gelenDegerler != null) {
                      gelenDegerler.forEach((key, nesne) {
                        var gelenOgretmen = Ogretmenler.fromJson(key, nesne);

                        ogretmenlerListesi.add(gelenOgretmen);

                        //Dropdownda öğretmenler isimlerine göre sıralanıyor

                        ogretmenlerListesi.sort(
                            (a, b) => a.ogretmen_ad.compareTo(b.ogretmen_ad));
                      });
                    }
                    return SizedBox(
                      width: ekranGenisligi / 1.644,
                      child: DropdownButton(
                        underline: Container(
                          height: 1,
                          color: Colors.teal,
                        ),
                        hint: Text("Seçiniz"),
                        value: secilenDeger,
                        items: ogretmenlerListesi.map((value) {
                          return DropdownMenuItem(
                              value: value.ogretmen_ad,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: ekranGenisligi / 4.56),
                                child: Text(value.ogretmen_ad),
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
            Padding(
              padding: EdgeInsets.all(ekranGenisligi / 51.375),
              child: SizedBox(
                width: ekranGenisligi / 1.644,
                child: TextField(
                  controller: controllerSifre,
                  obscureText: goster,
                  decoration: InputDecoration(
                      hintText: "Şifre",
                      suffixIcon: IconButton(
                        color: Colors.blue,
                        icon: goster
                            ? Icon(Icons.lock_open_sharp)
                            : Icon(
                                Icons.lock_outline_sharp,
                              ),
                        onPressed: () {
                          //Kilit Düğmesine bir kere basıldığında TextField karakterlerini gizler
                          //bir kere daha basıldığında gösterir
                          setState(() {
                            if (goster == true) {
                              goster = false;
                              return;
                            }
                            if (goster == false) {
                              goster = true;
                              return;
                            }
                          });
                        },
                      )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ekranGenisligi / 5,
              ),
              child: SizedBox(
                width: ekranGenisligi / 2.74,
                height: ekranGenisligi / 8.22,
                child: FlatButton(
                  color: Colors.teal,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  child: Container(
                    child: Row(children: [
                      Spacer(),
                      Text(
                        "Giriş",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ekranGenisligi / 20.55),
                      ),
                      Spacer(),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                        size: ekranGenisligi / 16.44,
                      )
                    ]),
                  ),
                  onPressed: () {
                    sifreGir();
                  },
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
