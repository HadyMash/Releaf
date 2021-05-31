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
  Future addNewJournalEntry(String date, String entryText, int feeling) async {
    try {
      await journal.set({
        "$date": {
          "entryText": entryText,
          "feeling": feeling,
        },
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  // TODO delete entry

  // TODO edit an entry

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
