import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation/Kutuphane/Klass/Odunc.dart';




class OduncDetay extends StatefulWidget {
  Odunc odunc;


  OduncDetay({this.odunc});

  @override
  _OduncDetayState createState() => _OduncDetayState();
}

class _OduncDetayState extends State<OduncDetay> {
  @override
  Widget build(BuildContext context) {


String tarih=widget.odunc.tarih;
var formatlanmistarih = DateFormat("dd/MM/yyyy").parse(tarih);
int sure=widget.odunc.odunc_sure;
var iadeTarihi=formatlanmistarih.add(Duration(days: sure));
String formatlanmisIadeTarihi=DateFormat("dd/MM/yyyy").format(iadeTarihi);









    var ekranGenisligi=MediaQuery.of(context).size.width;
    var ekranYuksekligi=MediaQuery.of(context).size.height;
    var satiraraligi=ekranYuksekligi/25;
    return Scaffold(appBar: AppBar(title: Text("Ödünç Detay"),),
    body: Center(
      child: SizedBox(
        width: ekranGenisligi/1.2,
        height: ekranYuksekligi/1.5,
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/20,bottom: satiraraligi*3,top: ekranYuksekligi/20),
                child: Align(
                  alignment: Alignment.centerLeft,
                    child: Text(widget.odunc.kitap_ad,style: TextStyle(fontSize: 25,color: Colors.black,))),
              ), //Kitap Adı

              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Öğrenci Ad:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.odunc.ogrenci_ad,style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Öğrenci Ad
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Sınıf:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.odunc.sinif, style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Öğrenci Sınıf
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Okul No:",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.odunc.okul_no.toString(),style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Verilen Tarih
              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("İade Tarihi",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(formatlanmisIadeTarihi,style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), //Okul No

              Padding(
                padding:  EdgeInsets.only(left: ekranGenisligi/10,bottom: satiraraligi),
                child: Row(

                  children: [
                    SizedBox(
                        width: ekranGenisligi/3,
                        child: Text("Öğretmen Ad",style: TextStyle(fontSize: 15,color: Colors.black45))),
                    Text(widget.odunc.ogretmen_ad,style: TextStyle(fontSize: 15,color: Colors.teal,))
                  ],
                ),
              ), // Öğretmen Ad
            ],
          ),
        ),
      ),
    ),);
  }
}
