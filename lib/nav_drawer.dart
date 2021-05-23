
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:movies_mim/authentication_service.dart';
import 'package:movies_mim/movie_pages.dart';
import 'package:movies_mim/sign_in_page.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(500,230, 57, 70),
            ),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Wszystkie'),
            onTap: () {
              HomeState.of(context).location = 0;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Obejrzane'),
            onTap: () {
            HomeState.of(context).location = 1;
            Navigator.of(context).pop();
          },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Do obejrzenia'),
            onTap: () {
              HomeState.of(context).location = 2;
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Wyloguj'),
            onTap: () => {context.read<AuthenticationService>().signOut(), Navigator.pop(context)},
          ),
        ],
      ),
    );
  }
}