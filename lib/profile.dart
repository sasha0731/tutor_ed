import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  SharedPreferences prefs;
  String name = '';
  String photoUrl = '';
  String email = '';
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    email = prefs.getString('email') ?? '';
    Dashboard.title = email.split("@")[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[photoUrl != '' ?
          Container(
            alignment: Alignment(0.0,-0.9),
            child: Material(
              child: CachedNetworkImage(
                placeholder: Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                  ),
                  width: 90.0,
                  height: 90.0,
                  padding: EdgeInsets.all(20.0),
                ),
                imageUrl: prefs.getString('photoUrl'),
                width: 90.0,
                height: 90.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              clipBehavior: Clip.hardEdge,
            ),
          ) : Container(),
          Container(
            alignment: Alignment(0.0, -0.3),
            child: Text(
              name,
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}