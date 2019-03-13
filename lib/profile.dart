import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String aboutMe = '';
  String id = '';
  int role = 0;
  int grade = 0;
  bool edit = false;
  TextEditingController _aboutMeController;
  TextEditingController _gradeController;
  final FocusNode focusNodeAboutMe = new FocusNode();
  final FocusNode focusNodeGrade = new FocusNode();

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
    id = prefs.getString('id') ?? '';
    role = prefs.getInt('role') ?? 0;
    grade = prefs.getInt('grade') ?? 0;
    aboutMe = prefs.getString('aboutMe') ?? '';
    Dashboard.title = email.split("@")[0];
    _aboutMeController = new TextEditingController(text: aboutMe);
    _gradeController = new TextEditingController(text: grade.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
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
                imageUrl: prefs.getString('photoUrl'),
                width: 90.0,
                height: 90.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              clipBehavior: Clip.hardEdge,
            ),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          ) : Container(),

          // name
          Container(
            alignment: Alignment(0.0, -0.3),
            child: Text(
              name,
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 45,
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ),

          // email
          Container(
            alignment: Alignment(0.0, -0.3),
            child: Text(
              email,
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 15,
              ),
            ),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
          ),

          // grade
          Container(
            child: edit ? TextFormField(
              controller: _gradeController,
              keyboardType: TextInputType.number,
              maxLines: 1,
            ) : new FocusScope(
              node: new FocusScopeNode(),
              child: new TextFormField(
                controller: _gradeController,
                decoration: new InputDecoration(
                  hintText: grade.toString(),
                ),
                maxLines: 1,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
          ),

          // about me
          Container(
            child: edit ? TextFormField(
              controller: _aboutMeController,
              maxLines: null,
            ) : new FocusScope(
              node: new FocusScopeNode(),
              child: new TextFormField(
                controller: _aboutMeController,
                decoration: new InputDecoration(
                  hintText: aboutMe,
                ),
                maxLines: null,
              ),
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),

          // about me button
          Container (
            child: FloatingActionButton.extended(
              onPressed: () => setState(() {
                edit = !edit;
                aboutMe = _aboutMeController.text;
                if (!edit) {
                  Firestore.instance
                    .collection('users')
                    .document(id)
                    .updateData({'aboutMe': aboutMe, 'grade': grade}).then((data) async {
                      await prefs.setString('aboutMe', aboutMe);
                      await prefs.setInt('grade', grade);
                    });
                }
              }),
              icon: edit ? Icon(
                Icons.edit,
                size: 0,
                color: Colors.transparent,
              ) : new Icon (
                Icons.edit,
              ),
              label: edit ? Text(
                'Done',
                style: TextStyle(fontSize: 14.0),
              ) : new Text(
                'Edit',
                style: TextStyle(fontSize: 14.0),
              ),
              backgroundColor: Colors.black54,
            ),
            padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)
          ),
        ],
      ),
    );
  }
}