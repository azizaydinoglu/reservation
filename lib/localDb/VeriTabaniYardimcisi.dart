import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Bu metot sayesinde veritabanı eğer oluşturulmamışsa kopyalanıp yeniden oluşturuluyor,
//eğer oluşturulmuşsa Veri tabanı zaten var.Kopyalamya Gerek yok diyor
class VeritabaniYardimcisi {
  static final String veritabaniAdi = "giris.sqlite";
  static Future<Database> veritabaniErisim() async {
    String veritabaniYolu = join(await getDatabasesPath(), veritabaniAdi);

    if (await databaseExists(veritabaniYolu)) {
      print("Veri tabanı zaten var.Kopyalamaya Gerek yok");
    } else {
      ByteData data = await rootBundle.load("veritabani/$veritabaniAdi");
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(veritabaniYolu).writeAsBytes(bytes, flush: true);
      print("Veri tabanı kopyalandı");
    }

    return openDatabase(veritabaniYolu);
  }
}
