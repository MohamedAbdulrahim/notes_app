import 'package:note_app/dbHelper.dart';

class Note {
  int _id;
  String _title;
  String _content;
  String _time;
  Note.newNote();
  Note(dynamic obj) {
    _id = obj[DbHelper.columnId];
    _title = obj[DbHelper.columnTitle];
    _content = obj[DbHelper.columnContent];
    _time = obj[DbHelper.columnTime];
  }
  Note.fromMap(Map<String, dynamic> data) {
    _id = data[DbHelper.columnId];
    _title = data[DbHelper.columnTitle];
    _content = data[DbHelper.columnContent];
    _time = data[DbHelper.columnTime];
  }
  Map<String, dynamic> toMap() => {
        DbHelper.columnId: _id,
        DbHelper.columnTitle: _title,
        DbHelper.columnContent: _content,
        DbHelper.columnTime: _time
      };

  int get id => _id;
  String get title => _title;
  String get content => _content;
  String get time => _time;
}
