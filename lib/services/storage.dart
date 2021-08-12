import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:releaf/services/encrypt.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class StorageService {
  final String uid;
  late final FirebaseStorage storage;
  StorageService(this.uid) {
    storage = FirebaseStorage.instance;
  }

  // upload picture(s)
  Future uploadPictures(
      {required List<Uint8List> pictures, required String entryID}) async {
    try {
      // TODO encrypt pictures
      EncryptService encryptService = EncryptService(uid);
      final ref = storage.ref('$uid/$entryID');
      for (Uint8List picture in pictures) {
        // Uint8List encryptedPicture = encryptService.encryptImage(picture);
        ref.child('${DateTime.now().toString()}.txt').putData(picture);
      }
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // delete pictures
  Future deletePictures(String entryID) async {
    try {
      final ref = storage.ref(uid).child(entryID);

      await ref.listAll().then((result) async {
        for (var picReference in result.items) {
          await ref.child(picReference.name).delete();
        }
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // get picture(s)
  Future getPictures(String entryID) async {
    try {
      EncryptService encryptService = EncryptService(uid);
      final ref = storage.ref(uid).child(entryID);
      List<Uint8List> pictures = [];

      await ref.listAll().then((result) async {
        for (var picReference in result.items) {
          Uint8List? pic = (await ref.child(picReference.name).getData());
          if (pic == null) {
            // TODO make no picture found picture
            var url = Uri.parse(
                'https://www.salonlfc.com/wp-content/uploads/2018/01/image-not-found-scaled-1150x647.png');
            var response = await http.get(url);
            pic = response.bodyBytes;
            pictures.add(pic);
          } else {
            // var decryptedPic = encryptService.decryptImage(pic);
            pictures.add(pic);
          }
        }
      });
      return pictures;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future deleteAllPictures(List<JournalEntryData> entries) async {
    try {
      for (var entry in entries) {
        deletePictures(entry.date);
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
