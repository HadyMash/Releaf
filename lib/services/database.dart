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
    journal = firestore.doc('journal/$uid');

    // * Tasks
    tasks = firestore.doc('tasks/$uid');
  }

  // * Journal
  late DocumentReference<Object?> journal;

  // add new entry
  Future addNewJournalEntry(String date, String entryText, int feeling,
      List<Uint8List> pictures) async {
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

      await journal.set({
        date: {
          "entryText": encryptedText,
          "feeling": feeling,
        },
      }, SetOptions(merge: true));
      return JournalEntryData(
        date: date,
        entryText: encryptedText,
        feeling: feeling,
        pictures: pictures,
      );
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  // delete entry
  Future deleteEntry(String date) async {
    try {
      await journal.set(
        {date: FieldValue.delete()},
        SetOptions(merge: true),
      );
      await StorageService(uid).deletePictures(date);
      return true;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // edit an entry
  Future editEntry(String oldDate, String newDate, String? entryText,
      int feeling, List<Uint8List> pictures) async {
    try {
      String encryptedText = EncryptService(uid).encrypt(entryText ?? '');
      if (oldDate == newDate) {
        await journal.set(
          {
            "$oldDate": {
              "entryText": encryptedText,
              "feeling": feeling,
            },
          },
          SetOptions(merge: true),
        );
      } else {
        deleteEntry(oldDate);
        DateTime oldDateTime = DateTime.parse(oldDate);
        DateTime newDateTime = DateTime.parse(newDate);
        DateTime hybridDate = DateTime(
          newDateTime.year,
          newDateTime.month,
          newDateTime.day,
          oldDateTime.hour,
          oldDateTime.minute,
          oldDateTime.second,
          oldDateTime.millisecond,
          oldDateTime.microsecond,
        );

        addNewJournalEntry(
            hybridDate.toString(), encryptedText, feeling, pictures);
      }
      // StorageService storage = StorageService(uid);
      // storage.deletePictures(oldDate);
      // storage.uploadPictures(pictures: pictures, entryID: newDate);
      return true;
    } catch (e) {
      print(e.toString());
    }
  }

  // get entries
  Future<List<JournalEntryData>> getJournalEntries() async {
    List<JournalEntryData> entries = [];
    print('getting journal entries');

    EncryptService encryptService = EncryptService(uid);

    await journal.get().then((document) async {
      Map data = (document.data() as Map);

      for (var mapEntry in data.entries) {
        dynamic pictures = await StorageService(uid).getPictures(mapEntry.key);
        entries.add(JournalEntryData(
          date: mapEntry.key,
          entryText: encryptService.decrypt(mapEntry.value['entryText']),
          feeling: mapEntry.value['feeling'],
          pictures: pictures,
        ));
      }
    });
    return entries;
  }

  // TODO review
  // ? Possible Refactor of getJournalEntries
  // from https://stackoverflow.com/a/68248269/15782390
  /*
  Future<List<JournalEntryData>> getJournalEntries() async {
  List<JournalEntryData> entries = [];
  print('getting journal entries');

  EncryptService encryptService = EncryptService(uid);

  final document = await journal.get();
  Map data = (document.data() as Map);
  print('about to loop through pictures');

  for (final mapEntry in data.entries) {
    final key = mapEntry.key;
    final value = mapEntry.value;

    print('getting picture');
    dynamic pictures = await StorageService(uid).getPictures(key);
    print('done getting image');
    entries.add(JournalEntryData(
      date: key,
      entryText: encryptService.decrypt(value['entryText']),
      feeling: value['feeling'],
      pictures: pictures,
    ));
  }
  print('returning entries');
  return entries;
}
  */

  // ! Dangerous
  Future _deleteAllEntries() async {
    try {
      List<JournalEntryData> entries = await getJournalEntries();
      for (var entry in entries) {
        await deleteEntry(entry.date);
      }
    } catch (e) {
      print(e);
      return e;
    }
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
      await _deleteAllEntries();

      // delete all tasks and task years
      await _deleteAllTasks();
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future _deleteAllTasks() async {
    try {
      List<dynamic> years = await getTaskYears();
      years.forEach((year) async {
        await deleteTaskYear(year as int);
      });
      await tasks.delete();
    } catch (e) {
      print(e);
      return e;
    }
  }
}
