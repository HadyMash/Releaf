import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:releaf/services/encrypt.dart';
import 'package:releaf/services/storage.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';
import 'package:releaf/shared/models/todo_data.dart';

class DatabaseService {
  final String uid;
  late final FirebaseFirestore firestore;
  DatabaseService({required this.uid}) {
    firestore = FirebaseFirestore.instance;

    // * Journal
    journal = firestore.collection('journal/$uid/entries');

    // * Tasks
    tasks = firestore.doc('tasks/$uid');
  }

  // * Journal
  late CollectionReference<Object?> journal;

  // add new entry
  Future addJournalEntry(String date, String entryText, int feeling) async {
    try {
      // DateTime currentDate = DateTime.now();
      // DateTime newDateTime = DateTime.parse(date);
      // DateTime hybridDate = DateTime(
      //   newDateTime.year,
      //   newDateTime.month,
      //   newDateTime.day,
      //   currentDate.hour,
      //   currentDate.minute,
      //   currentDate.second,
      //   currentDate.millisecond,
      //   currentDate.microsecond,
      // );
      String encryptedText = EncryptService(uid).encrypt(entryText);

      await journal.doc(date).set({
        "entryText": encryptedText,
        "feeling": feeling,
      });

      return JournalEntryData(
        date: date,
        entryText: encryptedText,
        feeling: feeling,
      );
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // delete entry
  Future deleteEntry(String date) async {
    try {
      await journal.doc(date).delete();

      await StorageService(uid).deletePictures(date);
      return true;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // // edit an entry
  // Future editEntry(String oldDate, String newDate, String? entryText,
  //     int feeling, List<Uint8List> pictures) async {
  //   try {
  //     String encryptedText = EncryptService(uid).encrypt(entryText ?? '');
  //     if (oldDate == newDate) {
  //       await journal.set(
  //         {
  //           "$oldDate": {
  //             "entryText": encryptedText,
  //             "feeling": feeling,
  //           },
  //         },
  //         SetOptions(merge: true),
  //       );
  //     } else {
  //       deleteEntry(oldDate);
  //       DateTime oldDateTime = DateTime.parse(oldDate);
  //       DateTime newDateTime = DateTime.parse(newDate);
  //       DateTime hybridDate = DateTime(
  //         newDateTime.year,
  //         newDateTime.month,
  //         newDateTime.day,
  //         oldDateTime.hour,
  //         oldDateTime.minute,
  //         oldDateTime.second,
  //         oldDateTime.millisecond,
  //         oldDateTime.microsecond,
  //       );

  //       addNewJournalEntry(hybridDate.toString(), encryptedText, feeling);
  //     }
  //     // StorageService storage = StorageService(uid);
  //     // storage.deletePictures(oldDate);
  //     // storage.uploadPictures(pictures: pictures, entryID: newDate);
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }

  // get entries
  Future<List<JournalEntryData>> getJournalEntries(
      {int? limit, List? startAfterValues}) async {
    List<JournalEntryData> entries = [];
    print('getting journal entries');

    EncryptService encryptService = EncryptService(uid);

    void _returnDataAsEntries(QuerySnapshot<Object?> snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map;
        entries.add(
          JournalEntryData(
            date: doc.id,
            entryText: encryptService.decrypt(data['entryText']),
            feeling: data['feeling'],
          ),
        );
      }
    }

    if (limit != null && startAfterValues != null) {
      await journal
          .limit(limit)
          .startAfter(startAfterValues)
          .get()
          .then((snapshot) async {
        _returnDataAsEntries(snapshot);
      });
    } else if (limit != null && startAfterValues == null) {
      await journal.limit(limit).get().then((snapshot) async {
        _returnDataAsEntries(snapshot);
      });
    } else {
      await journal.get().then((snapshot) {
        _returnDataAsEntries(snapshot);
      });
    }

    return entries;
  }

  // * Tasks
  late DocumentReference<Object?> tasks;

  // Get list of years
  Future<List<dynamic>> getTaskYears() async {
    print('getting task years');
    return tasks.get().then((value) => value.get('years'));
  }

  // Add a new year
  Future? addTaskYear(int year) async {
    try {
      EncryptService encryptService = EncryptService(uid);
      List years =
          await tasks.collection(year.toString()).get().then((snapshot) {
        return snapshot.docs;
      });
      await tasks.collection(year.toString()).add({
        'index': years.length == 0 ? 0 : years.length,
        'task': encryptService.encrypt('Celebrate New Year!'),
        'completed': false,
      });
      await tasks.update({
        'years': FieldValue.arrayUnion([year])
      });
    } catch (e) {
      print(e.toString());
      return Future.value(e);
    }
  }

  Future? deleteTaskYear(int year) async {
    try {
      // delete reference in document
      await tasks.update({
        'years': FieldValue.arrayRemove([year]),
      });

      // delete collection
      await tasks.collection(year.toString()).get().then((snapshot) async {
        for (DocumentSnapshot doc in snapshot.docs) {
          await doc.reference.delete();
        }
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Stream<List<TodoData>?> getTodos(int year) {
    EncryptService encryptService = EncryptService(uid);

    return tasks.collection(year.toString()).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoData(
          task: encryptService.decrypt(doc.data()['task']),
          completed: doc.data()['completed'],
          index: doc.data()['index'],
          docID: doc.id,
        );
      }).toList();
    });
  }

  // TODO add index functionality
  Future addTodo(
      {required String task, required int index, required int year}) async {
    try {
      EncryptService encryptService = EncryptService(uid);
      await tasks.collection(year.toString()).add({
        'index': index,
        'task': encryptService.encrypt(task),
        'completed': false,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future editTodo(
      {required String task, required int year, required String docID}) async {
    try {
      EncryptService encryptService = EncryptService(uid);
      await tasks.collection(year.toString()).doc(docID).update({
        'task': encryptService.encrypt(task),
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  Future deleteTodo({required int year, required String docID}) async {
    try {
      await tasks.collection(year.toString()).doc(docID).delete();
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

// TODO add index functinality
  Future completeTodo(int year, String docID) async {
    try {
      await tasks.collection(year.toString()).doc(docID).update({
        'completed': true,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

// TODO add index functionality
  Future uncompleteTodo(int year, String docID) async {
    try {
      await tasks.collection(year.toString()).doc(docID).update({
        'completed': false,
      });
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // ! Dangerous
  Future deleteUserData() async {
    try {
      // delete journal entries.
      print('deleting journal entries');
      await journal.get().then((snapshot) async {
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }
      });

      await firestore.collection('journal').doc(uid).delete();

      // delete tasks
      print('deleting tasks');
      await tasks.get().then((doc) async {
        var data = doc.data() as Map;
        List years = data['years'];
        print('deleting each task collections\' documents');
        for (int year in years) {
          await tasks
              .collection(year.toString())
              .get()
              .then((querySnapshot) async {
            for (var element in querySnapshot.docs) {
              await element.reference.delete();
            }
          });
        }
      });
      print('deleting tasks doc');
      await tasks.delete();
    } catch (e) {
      print(e);
      return e;
    }
  }
}
