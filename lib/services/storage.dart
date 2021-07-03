import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final String uid;
  late final FirebaseStorage storage;
  StorageService(this.uid) {
    storage = FirebaseStorage.instance;
  }

  // TODO upload picture(s)
  Future uploadPictures(
      {required List<Uint8List> pictures, required String entryID}) async {
    try {
      final ref = storage.ref('$uid/$entryID');
      pictures.forEach((picture) {
        ref.child('${DateTime.now().toString()}.txt').putData(picture);
      });
      print('done uploading');
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // TODO get picture(s)
}
