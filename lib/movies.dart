

import 'package:flutter/foundation.dart';

class Movie {
  String title;
  String director;
  int year;
  String genre;
  String notes;
  bool seen;
  String databaseReference;

  Movie({@required this.title, this.director = "", this.year, this.genre = "", this.notes = "", this.seen = false});
}