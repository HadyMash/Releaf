import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:releaf/shared/models/journal_entry_data.dart';

class DatabaseService {
  final String uid;
  late final FirebaseFirestore firestore;
  DatabaseService({required this.uid}) {
    firestore = FirebaseFirestore.instance;
    journal = firestore.doc('journal/$uid');
  }

  // * Journal
  late DocumentReference<Object?> journal;

  // add new entry
  // TODO make hash date identifier combination
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
}
