import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future addNewJournalEntry(String date, String entryText, int feeling) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime newDateTime = DateTime.parse(date);
      DateTime hybridDate = DateTime(
        newDateTime.year,
        newDateTime.month,
        newDateTime.day,
        currentDate.hour,
        currentDate.minute,
        currentDate.second,
        currentDate.millisecond,
        currentDate.microsecond,
      );
      await journal.set({
        hybridDate.toString(): {
          "entryText": entryText,
          "feeling": feeling,
        },
      }, SetOptions(merge: true));
      return JournalEntryData(
          date: date, entryText: entryText, feeling: feeling);
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
      return true;
    } catch (e) {
      print(e.toString());
      return e;
    }
  }

  // edit an entry
  Future editEntry(
      String oldDate, String newDate, String? entryText, int feeling) async {
    try {
      if (oldDate == newDate) {
        await journal.set(
          {
            "$oldDate": {
              "entryText": entryText,
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

        addNewJournalEntry(hybridDate.toString(), entryText ?? '', feeling);
      }
      return true;
    } catch (e) {
      print(e.toString());
    }
  }

  // get entries
  Future<List<JournalEntryData>> getJournalEntries() async {
    List<JournalEntryData> entries = [];
    print('getting journal entries');

    await journal.get().then((document) {
      Map data = (document.data() as Map);
      data.forEach((key, value) {
        entries.add(JournalEntryData(
          date: key,
          entryText: value['entryText'],
          feeling: value['feeling'],
        ));
      });
    });

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
      List years =
          await tasks.collection(year.toString()).get().then((snapshot) {
        return snapshot.docs;
      });
      await tasks.collection(year.toString()).add({
        'index': years.length == 0 ? 0 : years.length,
        'task': 'Celebrate New Year!',
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
    return tasks.collection(year.toString()).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return TodoData(
          task: doc.data()['task'],
          completed: doc.data()['completed'],
          index: doc.data()['index'],
          docID: doc.id,
        );
      }).toList();
    });
  }

  Future addTodo(String task, int index) async {}

  Future deleteTodo(String docID) async {}

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
}
