import 'package:flutter/material.dart';
import '../Note.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatefulWidget{

  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail>{
  DatabaseHelper helper = DatabaseHelper();
  String appBarTitle;
  Note note;

  NoteDetailState(this.note, this.appBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        backgroundColor: Colors.orangeAccent,
        appBar: AppBar(
          title: Text(appBarTitle),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body:  Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding:
                  EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                      icon: Icon(Icons.title),
                    ),
                  ),
                ),

                // Third Element
                Padding(
                  padding:
                  EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Details',
                      icon: Icon(Icons.details),
                    ),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: FloatingActionButton(
                          child: Text(
                            'Save',style: TextStyle(color: Colors.black),
                            textScaleFactor: 1.0,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 6.0,
                      ),
                      Expanded(
                        child: FloatingActionButton(
                          child: Text(
                            'Delete',style: TextStyle(color: Colors.black),
                            textScaleFactor: 1.0,
                          ),
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateTitle(){
    note.title = titleController.text;
  }
  void updateDescription(){
    note.description = descriptionController.text;
  }

  void _save() async{
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    }else{
      result = await helper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDialog("Status","Note Saved Successfully");
    }else{
      _showAlertDialog("Status","Problem In Saving Note");
    }
  }

  void _delete() async{
    moveToLastScreen();

    if(note.id==null){
      _showAlertDialog("Status","First Add a Note");
      return;
    }
    int result = await helper.deleteNote(note.id);

    if (result != 0) {
      _showAlertDialog("Status","Note Saved Successfully");
    }else{
      _showAlertDialog("Status","Sorry, Error");
    }

  }

  //Convert Priority to Int to Save it into Database
  void updatePriorityAsInt(String value){
    switch (value) {
      case "High":
        note.priority = 1;
        break;
      case "Low":
        note.priority = 2;
        break;
      default:
    }
  }

  //Converting the Priority into String for showing to User

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context:context, builder:(_) => alertDialog);
  }



}


