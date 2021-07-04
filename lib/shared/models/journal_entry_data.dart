import 'dart:typed_data';

class JournalEntryData {
  final String date;
  final String entryText;
  final int feeling;
  final List<Uint8List> pictures;

  JournalEntryData({
    required this.date,
    required this.entryText,
    required this.feeling,
    required this.pictures,
  });
}
