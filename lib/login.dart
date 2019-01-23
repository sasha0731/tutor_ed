import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}
class LoginState extends State<Login> {
  Authentication auth = new Authentication();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _initFirestore();
    auth.isSignedIn(context);
  }
  void _initFirestore() async {
    await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  }
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      body: Stack (
        children: <Widget>[
          Container (
            alignment: Alignment(0.0, -0.8),
            child: Text (
              'TutorED',
              style: new TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 0.06*height,
              ),
            textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: FlatButton(
              onPressed: () => auth.signIn(context),
              child: Text(
                'SIGN IN WITH GOOGLE',
                style: TextStyle(fontSize: 14.0),
              ),
              color: Color(0xffdd4b39),
              highlightColor: Color(0xffff7f7f),
              splashColor: Colors.transparent,
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: auth.isLoading,
            builder: (context, value, child) {
              return Container (
                child: auth.isLoading.value
                    ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ): Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}