import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'conversation.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot document;
  Profile({Key key, this.document}) : super(key: key);
  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  SharedPreferences prefs;
  String name = '';
  String photoUrl = '';
  String email = '';
  String aboutMe = '';
  String id = '';
  int role = 0;
  int grade = 0;

  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.document == null) {
      prefs = await SharedPreferences.getInstance();
      name = prefs.getString('name') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      email = prefs.getString('email') ?? '';
      id = prefs.getString('id') ?? '';
      role = prefs.getInt('role') ?? 0;
      grade = prefs.getInt('grade') ?? 0;
      aboutMe = prefs.getString('aboutMe') ?? '';
    } else {
      name = widget.document['name'] ?? '';
      photoUrl = widget.document['photoUrl'] ?? '';
      email = widget.document['email'] ?? '';
      id = widget.document['id'] ?? '';
      role = widget.document['role'] ?? '';
      grade = widget.document['grade'] ?? 0;
      aboutMe = widget.document['aboutMe'] ?? '';
    }
    Dashboard.title = email.split('@')[0];
    setState(() {});
  }
  Future navigateToConversation(context, DocumentSnapshot document) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(document: document,)));
  }
  @override
  Widget build(BuildContext context) {
    Container profile =  new Container (
      decoration: BoxDecoration(color: Colors.transparent),
      child: Align (
        child: Container (
          alignment: Alignment(0,0),
          decoration: new BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: <Widget>[
              // picture
              photoUrl != '' ? Container(
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
                    imageUrl: photoUrl,
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
              ) : Container(),

              Center (
                child: Text(
                  name,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 32,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),

              // email
              Center(
                child: Text(
                  email,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              ),

              // grade
              Center(
                child: Text(
                  'Grade ' + grade.toString(),
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
              ),

              // about me
              Center(
                child: Text(
                  aboutMe,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              ),
            ],
          ),
        )
      )
    );
    if (widget.document == null) {
      return profile;
    } else {
      return new Scaffold (
        appBar: PreferredSize (
          preferredSize: Size.fromHeight(50),
          child: AppBar (
            title: new Text(
              name,
              style: new TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 30.0,
              ),
            ),

            actions: <Widget>[
              IconButton (
                icon: Icon(Icons.message),
                tooltip: 'Chat',
                onPressed: () {
                  navigateToConversation(context, widget.document);
                },
              )
            ],
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        body: profile,
      );
    }
  }
}