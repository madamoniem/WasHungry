import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  String getDownloadURL = "";
  Future<String> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    TaskSnapshot uploadTask =
        await storage.ref('foodItemImages/$fileName').putFile(file);

    String pathdownlaod = await uploadTask.ref.getDownloadURL();
    return pathdownlaod;
  }
}
