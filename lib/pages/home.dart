import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:note_app/model/Note.dart';
import 'package:note_app/constants.dart';
import 'package:note_app/dbHelper.dart';
import 'package:note_app/pages/NewNote.dart';

class Home extends StatefulWidget {
  static final route = '/';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color itemColor = Colors.black;
  bool isDarkMode = false;
  DbHelper helper;
  bool isSearching = false;
  String textSearch = '';
  int notesLength = 0;
  bool isRefresh = false;
  @override
  void initState() {
    super.initState();
    helper = DbHelper();
    helper.allNotes().then((value) {
      setState(() {
        notesLength = value.length;
      });
    });
    BackButtonInterceptor.add(interceptorNote);
  }

  bool interceptorNote(bool sdbEvent, RouteInfo info) {
    setState(() {
      if (isSearching) {
        isSearching = false;
      } else {
        SystemNavigator.pop();
      }
    });
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(interceptorNote);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    setState(() {
                      toggleTheme();
                      isDarkMode = !isDarkMode;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lightbulb),
                      Text(isDarkMode ? 'To Light' : 'To Dark')
                    ],
                  )),
            ),
            Expanded(
              child: FlatButton(
                  onPressed: notesLength == 0
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Color(Constants.redColor),
                                    ),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Color(Constants.redColor)),
                                    )
                                  ],
                                ),
                                content: Text(
                                    'Are you sure!\nyou want to delete all notes?'),
                                actions: [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'No',
                                      style: TextStyle(color: Colors.grey[900]),
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        helper.deleteAllNotes();
                                        notesLength = 0;
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Color(Constants.redColor)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.delete_rounded,
                      ),
                      Text('Delete notes')
                    ],
                  )),
            ),
            Expanded(
              child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(NewNote.route);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.note_add), Text('Add a note')],
                  )),
            ),
          ],
        ),
      ),
      appBar: AppBar(
          actions: [
            IconButton(
                icon: isSearching ? Icon(Icons.search_off) : Icon(Icons.search),
                onPressed: notesLength == 0
                    ? null
                    : () {
                        setState(() {
                          isSearching = !isSearching;
                          if (!isSearching) {
                            textSearch = '';
                          }
                        });
                      })
          ],
          title: isSearching
              ? TextField(
                  onChanged: (value) {
                    setState(() {
                      textSearch = value;
                    });
                  },
                  autofocus: true,
                  decoration: InputDecoration(hintText: 'Search note'),
                )
              : Text(
                  'Pen notes',
                  style: TextStyle(
                      color: Color(Constants.redColor),
                      fontWeight: FontWeight.bold),
                )),
      body: notesLength > 0
          ? FutureBuilder(
              future: helper.allNotes(text: textSearch),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Note note = Note.fromMap(snapshot.data[index]);
                      return Dismissible(
                        key: UniqueKey(),
                        child: Card(
                          elevation: 1.5,
                          child: ListTile(
                            title: Text(
                              note.title,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            subtitle: Text(
                                note.content.substring(
                                    0,
                                    note.content.length > 16
                                        ? 16
                                        : note.content.length),
                                style: Theme.of(context).textTheme.bodyText2),
                            trailing: Text(
                              '${note.time}',
                              style: TextStyle(color: Colors.grey),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => NewNote(note, false)),
                              );
                            },
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          color: Color(Constants.redColor),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          Scaffold.of(context).removeCurrentSnackBar();
                          helper.deleteNote(note);
                          notesLength--;
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Delete note!'),
                              action: SnackBarAction(
                                  label: 'Prevent Deleting',
                                  onPressed: () {
                                    setState(() {
                                      helper.insertNote(note);
                                      notesLength++;
                                    });
                                  }),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
          : Center(
              child: Text('No notes'),
            ),
    );
  }

  void toggleTheme() {
    if (Theme.of(context).brightness == Brightness.light) {
      DynamicTheme.of(context).setBrightness(Brightness.dark);
      // put the value into sharedPreference
      itemColor = Colors.white;
    } else {
      DynamicTheme.of(context).setBrightness(Brightness.light);
      // put the value into sharedPreference
      itemColor = Colors.black;
    }
  }
}
