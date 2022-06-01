import 'package:flutter/material.dart';
import 'package:reservation/Kutuphane/Klass/KitapFirebase.dart';

class KitapDetay extends StatefulWidget {
  KitapFirebase kitap;

  KitapDetay({this.kitap});

  @override
  _KitapDetayState createState() => _KitapDetayState();
}

class _KitapDetayState extends State<KitapDetay> {
  @override
  Widget build(BuildContext context) {
    bool kitapNerede;
    var ekranGenisligi=MediaQuery.of(context).size.width;
    var ekranYuksekligi=MediaQuery.of(context).size.height;
    var satiraraligi=ekranYuksekligi/15;
    if (widget.kitap.durum=="0"){ kitapNerede=true;} else {kitapNerede=false;}
    return Scaffold(
      appBar: AppBar(title: Text("Kitap Detay"),),
        body: Center(

      child: SizedBox(
        width: ekranGenisligi/1.2,
        height: ekranYuksekligi/1.3,
        child: Card(
          elevation: 5,
          child: Column(

            children: [

              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi,top: ekranYuksekligi/10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.kitap.ad,style: TextStyle(fontSize: 25,color: Colors.black,))),
              ), //Kitap Ad
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Barkod No:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.kitap.barkod_no.toString(),style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Barkod No
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                      width: ekranGenisligi/3,
                        child: Text("Yazar:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.kitap.yazar,style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ) , // Yazar
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Kategori:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.kitap.kategori,style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), // Kategori
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Sayfa Sayısı:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.kitap.sayfasayisi.toString(),style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Sayfa Sayısı
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom:satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Nerede:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(kitapNerede ?"Rafta":"Okuyucuda",style: TextStyle(fontSize: 15,color:kitapNerede ? Colors.teal : Colors.red,))
                  ],
                ),
              ), //Nerede





            ],
          ),
        ),
      ),
    ));
  }
}
