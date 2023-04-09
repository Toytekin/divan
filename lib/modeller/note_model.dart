import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 6)
class NoteModel {
  @HiveField(0)
  String noteID;

  @HiveField(1)
  String baslik;

  @HiveField(2)
  String note;

  @HiveField(3)
  DateTime tarih;

  NoteModel({
    required this.noteID,
    required this.baslik,
    required this.note,
    required this.tarih,
  });
}
