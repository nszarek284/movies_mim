import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_mim/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:movies_mim/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:movies_mim/nav_drawer.dart';
import 'package:movies_mim/movies.dart';
import 'package:custom_switch/custom_switch.dart';
import 'package:movies_mim/AddMovie.dart';
import 'package:movies_mim/UpdateMovie.dart';
import 'package:search_page/search_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  static HomeState of(BuildContext context) {
    return context.findAncestorStateOfType<HomeState>();
  }

  int _location = 0;

  set location(int newLocation) {
    setState(() {
      _location = newLocation;
    });
  }

  final titles = {0: "Wszystkie", 1: "Obejrzane", 2: "Do obejrzenia"};

  @override
  Widget build(BuildContext context) {
    Widget _body;

    if (_location == 0)
      _body = AllMovies();
    else if (_location == 1)
      _body = SeenMovies();
    else if (_location == 2)
      _body = NotSeenMovies();
    else
      throw Exception("Invalid location");

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_location]),
        backgroundColor: Color.fromARGB(500,29, 53, 87),
      ),
      drawer: NavDrawer(),
      body: _body,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(500,230, 57, 70),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddEditMovie())),
        child: Icon(Icons.add),
      ),
    );
  }
}

class AllMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(context.read<User>().uid)
          .collection("Movies")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return Center(child: Text("Loading..."));
        return SingleChildScrollView(
          child: ListView(
              shrinkWrap: true,
              children: snap.data.docs
                  .map((qes) => MoviesData(Movie(
                      title: qes.get("Title"),
                      director: qes.get("Director"),
                      year: qes.get("Year"),
                      genre: qes.get("Genre"),
                      notes: qes.get("Notes"),
                      seen: qes.get("Seen"))..databaseReference = qes.id
              ))
                  .toList()),
        );
      },
    );
  }
}

class MoviesData extends StatelessWidget {
  final Movie movie;

  MoviesData(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: new EdgeInsets.fromLTRB(10, 10, 20, 10),
          title:
              Column(
          children:
                  [
                Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                  children:[
                    Flexible(child: Text(movie.title + (movie.director.isNotEmpty ?", " + movie.director: ""), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)))]),
                  Row(
                   children: [
                     Flexible(
                       child: Text(
                         movie.year.toString() + ", " + (movie.seen? "(obejrzane)": "(nieobejrzane)"), style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.black54)),
                     )])])
                    ,]),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddEditMovie(movie: movie)));
          },
        ),
      ],
    );
  }
}

class SeenMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(context.read<User>().uid)
          .collection("Movies")
          .where("Seen", isEqualTo: true)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return Center(child: Text("Loading..."));
        return SingleChildScrollView(
          child: ListView(
              shrinkWrap: true,
              children: snap.data.docs
                  .map((qes) => MoviesData(Movie(
                  title: qes.get("Title"),
                  director: qes.get("Director"),
                  year: qes.get("Year"),
                  genre: qes.get("Genre"),
                  notes: qes.get("Notes"),
                  seen: qes.get("Seen"))..databaseReference = qes.id
              ))
                  .toList()),
        );
      },
    );
  }
}

class NotSeenMovies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(context.read<User>().uid)
          .collection("Movies")
          .where("Seen", isEqualTo: false)
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return Center(child: Text("Loading..."));
        return SingleChildScrollView(
            child: ListView(
                shrinkWrap: true,
                children: snap.data.docs
                    .map((qes) => MoviesData(Movie(
                    title: qes.get("Title"),
                    director: qes.get("Director"),
                    year: qes.get("Year"),
                    genre: qes.get("Genre"),
                    notes: qes.get("Notes"),
                    seen: qes.get("Seen"))..databaseReference = qes.id
                ))
                    .toList())
        );
      },
    );
  }
}
