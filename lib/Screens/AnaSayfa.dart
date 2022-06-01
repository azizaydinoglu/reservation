import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation/Kutuphane/Screens/Ayarlar/Ayarlar.dart';
import 'package:reservation/Kutuphane/Screens/Kitap/Kitap.dart';
import 'package:reservation/Kutuphane/Screens/KutuphaneAnaSayfa.dart';
import 'package:reservation/Kutuphane/Screens/Odunc/OduncIslemleri.dart';
import 'package:reservation/Kutuphane/Screens/Raporlar.dart';
import 'package:reservation/Rezarvasyon/RezarvasyonAnaSayfa.dart';
import 'package:reservation/Screens/KarsilamaSayfa.dart';
import 'package:reservation/Screens/SifreDegistir.dart';
import 'package:reservation/UserOperations/KullaniciAyarlarAnaSayfa.dart';
import 'package:reservation/dbHelper/Ogretmenler.dart';
import 'package:reservation/localDb/VeriTabaniYardimcisi.dart';
import 'package:reservation/main.dart';

class Anasayfa extends StatefulWidget {
  String ogretmen_ad;

  Anasayfa({this.ogretmen_ad});

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  //Kullanıcı işlemleri yazısını açıp kapatmaya yarıyor
  bool gosterilsinMI = false;

  //Kullanıcı çıkış yaptığında localden de siliniyor ve Login Page e geri dönüyor
  Future<void> cikisYap() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete("oturum");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  //Drawer ın sayfa listesi
  //Karşılama sayfası altta indexe eklenmesi dolayısıyla sadece bir kere açılışta gösteriliyor
  var sayfaListe = [
    KarsilamaSayfa(),
    KutuphaneAnaSayfa(),
    RezarvasyonAnaSayfa(),
    SifreDegistir(),
    KullaniciAyarlarAnaSayfa(),
    Kitap(),
    OduncIslemleri(),
    Raporlar(), //Kütüphane
    Ayarlar(), //Kütüphane


  ];

  //0. indexten başlar
  int secilenIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Aşağıdaki fonksiyona gerek yok. Bir süre test edildikten sonra
    // silinebilir


    /*Future<void> ogretmenRolGuncelle(String ogretmen_ad, int ogretmen_rol) async {
      var db = await VeritabaniYardimcisi.veritabaniErisim();
      var bilgiler = Map<String, dynamic>();
      bilgiler["ogretmen_rol"] = ogretmen_rol;
      await db.update("oturum", bilgiler,
          where: "ogretmen_ad=?", whereArgs: [ogretmen_ad]);
    }*/

    //Aşağıdaki olay, kullanıcı sisteme local den giriş yaptığı için oluşturuluyor
    // Kullanıcı bu sayfaya gelse de Firebaseden tekrar varolup olmaığına bakılıp
    //varsa devam ediyor yoksa sistemden tekrar atılıyor.

    var refOgretmenler =
        FirebaseDatabase.instance.reference().child("ogretmenler");
    refOgretmenler.onValue.listen((event) {
      var gelenDegerler = event.snapshot.value;
      int ogretmensay = 0;
      if (gelenDegerler != null) {
        gelenDegerler.forEach((key, nesne) {
          var gelenOgretmen = Ogretmenler.fromJson(key, nesne);
          if (gelenOgretmen.ogretmen_ad == widget.ogretmen_ad) {
            ogretmensay++;
            if (gelenOgretmen.ogretmen_rol == 1) {

             // ogretmenRolGuncelle(widget.ogretmen_ad, 1);

              setState(() {
                gosterilsinMI = true;
                return;
              });
            } else {
            //  ogretmenRolGuncelle(widget.ogretmen_ad, 2);
              setState(() {
                gosterilsinMI = false;
                return;
              });
            }
          } else {}
        });
      }
      if (ogretmensay == 0) {

        //Firebase tarafında kullanıcı aranıyor eğer yoksa sistemden atılıyor
        cikisYap();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var ekranBilgisi = MediaQuery.of(context);
    var ekranGenisligi = ekranBilgisi.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Okul Otomasyon Sistemi"),
      ),
      body: sayfaListe[secilenIndex],
      drawer: Container(
        width: ekranGenisligi / 1.644,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [

              DrawerHeader(

                
                child: Column(
                  children: [
                    Icon(
                      Icons.account_circle_outlined,
                      size: ekranGenisligi / 5,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ekranGenisligi / 35),
                      child: Text(
                        widget.ogretmen_ad,
                        style: TextStyle(
                            color: Colors.white, fontSize: ekranGenisligi / 20),
                      ),
                    ),


                  ],
                ),
                decoration: BoxDecoration(color: Colors.teal),
              ),

              ExpansionTile(
                title: Text("Kütüphane"),
                leading: Icon(Icons.local_library_sharp),

                children: <Widget>[

                  Padding(
                    padding:  EdgeInsets.only(left:ekranGenisligi/18),
                    child: ListTile(

                      title: Text("Kitap İşlemleri "),
                      leading:FaIcon(FontAwesomeIcons.book,size: 20,) ,
                      onTap: (){
                        setState(() {
                          secilenIndex=5;
                        });
                        Navigator.pop(context);

                      },
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: ekranGenisligi/18),
                    child: ListTile(

                      title: Text("Ödünç İşlemleri "),
                      leading:Icon(Icons.wifi_protected_setup),
                      onTap: (){
                        setState(() {
                          secilenIndex=6;
                        });
                        Navigator.pop(context);

                      },
                    ),

                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: ekranGenisligi/18),
                    child: ListTile(

                      title: Text("Raporlar"),
                      leading:Icon(Icons.attachment),
                      onTap: (){
                        setState(() {
                          secilenIndex=7;
                        });
                        Navigator.pop(context);

                      },
                    ),

                  ),
                  Visibility(
                    visible: gosterilsinMI,
                    child: Padding(
                      padding:  EdgeInsets.only(left: ekranGenisligi/18),
                      child: ListTile(

                        title: Text("Ayarlar"),
                        leading:Icon(Icons.settings),
                        onTap: (){
                          setState(() {
                            secilenIndex=8;
                          });
                          Navigator.pop(context);

                        },
                      ),

                    ),
                  ),



                ],
              ),//5

              ListTile(
                title: Text("Konferans Salonu"),
                leading: FaIcon(FontAwesomeIcons.briefcase,size: 20,),
                onTap: () {
                  setState(() {
                    secilenIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ), //2
              Divider(),
              ListTile(
                title: Text("Şifre Değiştir"),
                leading: Icon(Icons.settings),
                onTap: () {
                  setState(() {
                    secilenIndex = 3;
                  });
                  Navigator.pop(context);
                },
              ), //3
              Divider(),

              Padding(
                padding:  EdgeInsets.only(left: 50,right: 50,top: ekranBilgisi.size.height/4),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.teal)),
                  onPressed: () {
                    cikisYap();
                  },
                 // padding: EdgeInsets.all(10.0),
                  color: Colors.white,
                  textColor: Colors.teal,
                  child: Text("Çıkış",
                      style: TextStyle(fontSize: 15)),
                ),
              ),

              // rolü 1 olanlar bu kısmı görebiliyor, 2 olanlar göremiyor

              Visibility(
                visible: gosterilsinMI,
                child: ListTile(
                  title: Text("Kullanıcı İşlemleri"),
                  leading: Icon(Icons.supervised_user_circle_outlined),
                  onTap: () {
                    setState(() {
                      secilenIndex = 4;
                    });
                    Navigator.pop(context);
                  },
                ),
              ) //4
            ],
          ),
        ),
      ),
    );
  }
}
