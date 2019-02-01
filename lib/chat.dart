import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State<Chat> {
  SharedPreferences prefs;
  String id = '';
  int role = -1;
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    role = prefs.getInt('role') ?? -1;
    setState(() {});
  }

  Widget buildUser(BuildContext context, DocumentSnapshot document, int r) {
    if (document['id'] == id || document['role'] == r || r == -1) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: CachedNetworkImage(
                  placeholder: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Name: ${document['name']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            print('Email -> ' + document['email'].toString());
          },
          color: Theme.of(context).primaryColorLight,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }

  Widget buildChatList(int r) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildUser(context, snapshot.data.documents[index], r),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }



  int value = 0;
  final Map<int, Widget> options = const <int, Widget>{
    0: Text('Students'),
    1: Text('Tutors'),
  };

  Widget buildSegmentedControl() {
    if (role == 0) {
      Dashboard.title = 'Students';
      return buildChatList(role);
    } else if (role == 1) {
      Dashboard.title = 'Tutors';
      return buildChatList(role);
    } else if (role == 2) {
      return Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          SizedBox (
            width: 500,
            child: CupertinoSegmentedControl<int>(
              borderColor: Theme.of(context).accentColor,
              selectedColor: Theme.of(context).accentColor,
              pressedColor: Theme.of(context).unselectedWidgetColor,
              children: options,
              onValueChanged: (int val) {
                setState(() {
                  value = val;
                });
              },
              groupValue: value,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          Expanded (
            child: Container (
              child: buildChatList(1-value),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          Container(
            child: buildSegmentedControl(),
          ),
        ],
      ),
    );
  }
}