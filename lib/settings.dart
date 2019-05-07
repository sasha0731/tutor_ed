import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  final TextEditingController _gradeController = new TextEditingController();
  final TextEditingController _aboutMeController = new TextEditingController();
  SharedPreferences prefs;
  String name = '';
  String id = '';
  int grade = 0;
  String aboutMe = '';
  String photoUrl = '';
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    id = prefs.getString('id') ?? '';
    grade = prefs.getInt('grade') ?? 0;
    aboutMe = prefs.getString('aboutMe') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    _gradeController.text = grade.toString();
    _aboutMeController.text = aboutMe;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize (
        preferredSize: Size.fromHeight(50),
        child: AppBar (
          title: new Text(
            'Settings',
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 30.0,
            ),
          ),
          actions: <Widget>[
            IconButton (
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () {
                setState(() {
                  Firestore.instance
                      .collection('users')
                      .document(id)
                      .updateData({'aboutMe': _aboutMeController.text, 'grade': int.parse(_gradeController.text)}).then((data) async {
                    await prefs.setString('aboutMe', _aboutMeController.text);
                    await prefs.setInt('grade', int.parse(_gradeController.text));
                  });
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                });
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: ListView(
        children: <Widget>[
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
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ) : Container(),

          Center (
            child: Text(
              name,
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 24,
              ),
            ),
          ),

          Padding (
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          ),
          // grade
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Grade:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox (
                  width: 30,
                  child: TextFormField(
                    controller: _gradeController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          ),

          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'About Me:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox (
                  width: 250,
                  child: TextFormField(
                    controller: _aboutMeController,
                    maxLines: null,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
          ),
        ],
      ),
    );
  }
}
