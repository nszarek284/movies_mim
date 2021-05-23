import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies_mim/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:movies_mim/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:movies_mim/nav_drawer.dart';
import 'package:movies_mim/movies.dart';
import 'package:custom_switch/custom_switch.dart';

class UpdateMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UpdateState();
}

class UpdateState extends State<UpdateMovie> {
  final TextEditingController title = TextEditingController();
  final TextEditingController director = TextEditingController();
  final TextEditingController genre = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edytuj film"),
          backgroundColor: Color.fromRGBO(29, 53, 87, 100),
        ),
        body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(children: [
                      Switch(
                        value: isSwitched,
                        onChanged: (value) {
                          setState(() {
                            isSwitched = value;
                            print(isSwitched);
                          });
                        },
                        activeTrackColor: Colors.lightGreenAccent,
                        activeColor: Colors.green,
                      )
                    ]),
                    TextFormField(
                      validator: (text) {
                        if(text.trim().isEmpty)
                          return "Tytuł jest wymagany";
                        return null;
                      },
                      controller: title,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelText: "Tytuł",
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: director,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelText: "Reżyser",
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: genre,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelText: "Gatunek",
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: year,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelText: "Rok",
                      ),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: notes,
                      decoration: InputDecoration(
                        contentPadding: new EdgeInsets.fromLTRB(0, 30, 0, 20),
                        labelText: "Notatka",
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 50, 0, 20),
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        onPressed: () {
                          //FirebaseFirestore.instance.runTransaction((transaction) async {
                          // DocumentSnapshot snapshot = await transaction.get(document.reference);
                          //await  transaction.set(snapshot.reference, {});});
                        },
                        child: Text("Aktalizuj"),
                        textColor: Colors.white,
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

}