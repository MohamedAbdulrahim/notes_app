import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/dbHelper.dart';
import 'package:note_app/pages/home.dart';
import 'package:share/share.dart';

import '../constants.dart';

class NewNote extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  NewNote(
    this.note,
    this.isNewNote,
  );
  static final route = '/NewNote';
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  // Note note;
  // bool isNewNote;
  // _NewNoteState(this.note, this.isNewNote);

  String time;
  DbHelper helper;
  bool isNewNote;
  Note note;

  String title;
  String content;
  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    isNewNote = widget.isNewNote;
    note = widget.note;
  }

  @override
  Widget build(BuildContext context) {
    String title = isNewNote ? '' : note.title;
    String content = isNewNote ? '' : note.content;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.share_rounded),
            onPressed: () {
              Share.share(content, subject: title);
            },
          )
        ],
        title: Text(
          isNewNote ? 'Add new note' : 'Modify note',
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) async {
                  title = value;
                },
                initialValue: title,
                autofocus: true,
                maxLength: 32,
                validator: (value) =>
                    value.length > 32 ? 'Maximum: 32 characters' : null,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Color(Constants.redColor)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(Constants.redColor),
                    ),
                  ),
                  labelText: 'Title',
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextFormField(
                minLines: 6,
                onChanged: (value) {
                  content = value;
                },
                initialValue: content,
                maxLines: 10,
                maxLength: 255,
                validator: (value) =>
                    value.length > 255 ? 'Maximum: 255 characters' : null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Color(Constants.redColor)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(Constants.redColor),
                    ),
                  ),
                  labelText: 'content',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.save),
        onPressed: () async {
          if (formKey.currentState.validate()) {
            DateTime dateTimeNow = DateTime.now();
            int year = dateTimeNow.year;
            int month = dateTimeNow.month;
            int day = dateTimeNow.day;
            int hour = dateTimeNow.hour;
            hour = hour <= 12 ? hour : hour - 12;
            int minute = dateTimeNow.minute;
            int second = dateTimeNow.second;
            String midday = hour < 12 ? 'AM' : 'PM';

            time = '$year/$month/$day\n$hour:$minute:$second ' + midday;

            Note note = Note({
              'id': widget.note.id,
              'title': title,
              'content': content,
              'time': time,
            });

            if (isNewNote) {
              await helper.insertNote(note);
            } else {
              await helper.updateNote(note);
            }

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false);
          }
        },
        label: Text(
          isNewNote ? 'Save' : 'Update',
        ),
      ),
    );
  }
}
