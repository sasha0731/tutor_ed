import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  SharedPreferences prefs;
  String name = '';
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    Dashboard.title = 'TutorED';
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return new Container (
      decoration: BoxDecoration(color: Colors.transparent),
//      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Align (
        child: Container (
          alignment: Alignment(0,0),
          decoration: new BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: <Widget>[
              Center (
                child: Text(
                  'Hello ' + name.split(' ')[0] + '!',
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
