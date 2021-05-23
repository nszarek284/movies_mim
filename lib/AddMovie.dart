import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_mim/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:movies_mim/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:movies_mim/nav_drawer.dart';
import 'package:movies_mim/movies.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:search_page/search_page.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddEditMovie extends StatefulWidget {
  final Movie movie;
  AddEditMovie({this.movie});
  @override
  State<StatefulWidget> createState() => AddState();
}

class AddState extends State<AddEditMovie> {
  bool isInstructionView;
  @override
  void initState() {
    isSwitched = widget.movie?.seen?? false;
    super.initState();
  }
  static final yearRegex = RegExp("[1-9][0-9][0-9][0-9]");
  final TextEditingController title = TextEditingController();
  final TextEditingController director = TextEditingController();
  final TextEditingController genre = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    if(widget.movie != null) {
      title.text = widget.movie.title;
      director.text = widget.movie.director;
      genre.text = widget.movie.genre;
      year.text = widget.movie.year.toString();
      notes.text = widget.movie.notes;
    }
    final node = FocusScope.of(context);
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
        IconButton(icon: Icon(Icons.delete), onPressed: deleteMovieFunction)],
          title: Text("Dodaj film"),
          backgroundColor: Color.fromARGB(500,29, 53, 87),
        ),
        body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Widziałeś? ", style: TextStyle(color: Colors.black87),),
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        
                        activeTrackColor: Color.fromARGB(100,230, 57, 70),
                        activeColor: Color.fromARGB(500,230, 57, 70),
                      )
                    ]),
                    TextFormField(
                      validator: (text) {
                        if(text.trim().isEmpty)
                          return "Tytuł jest wymagany";
                        return null;
                      },
                      onEditingComplete: () => node.nextFocus(),
                      controller: title,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: "Tytuł",
                      ),
                    ),
                    TextFormField(
                      onEditingComplete: () => node.nextFocus(),
                      controller: director,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: "Reżyser",
                      ),
                    ),
                    TextFormField(
                      onEditingComplete: () => node.nextFocus(),
                      controller: genre,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: "Gatunek",
                      ),
                    ),
                    TextFormField(
                      onEditingComplete: () => node.nextFocus(),
                      validator: (text) {
                        if(!yearRegex.hasMatch(text)) {
                          return "Podano nieprawidłową wartość";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      controller: year,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: "Rok",
                      ),
                    ),
                    TextFormField(
                      onEditingComplete: widget.movie == null ?
                      addMovieFunction: editMovieFunction,
                      controller: notes,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelStyle: TextStyle(color: Colors.black87),
                        labelText: "Notatka",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: widget.movie == null ?
                        addMovieFunction: editMovieFunction,
                        child: widget.movie == null ?
                        Text("Dodaj"): Text("Edytuj"),
                        textColor: Colors.white,
                        color: Color.fromARGB(500,230, 57, 70),
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  void editMovieFunction() {
    if(formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(context
          .read<User>()
          .uid)
          .collection("Movies")
          .doc(widget.movie.databaseReference).update({
        "Title": title.text.trim(),
        "Director": director.text.trim(),
        "Genre": genre.text.trim(),
        "Year": int.parse(year.text.trim()),
        "Notes": notes.text.trim(),
        "Seen": isSwitched
      });
      Navigator.pop(context);
    }
  }

  void addMovieFunction() {
    if(formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(context
          .read<User>()
          .uid)
          .collection("Movies")
          .add({
        "Title": title.text.trim(),
        "Director": director.text.trim(),
        "Genre": genre.text.trim(),
        "Year": int.parse(year.text.trim()),
        "Notes": notes.text.trim(),
        "Seen": isSwitched
      });
      Navigator.pop(context);
    }
  }
  void deleteMovieFunction() {
    if(formKey.currentState.validate()) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(context
          .read<User>()
          .uid)
          .collection("Movies")
          .doc(widget.movie.databaseReference).delete();
      Navigator.pop(context);
    }
  }
}