import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'dart:async';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication authentication = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken
    );
    return user;
  }

  void signOut() {
    googleSignIn.signOut();
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}

class Login extends StatefulWidget {
//  static bool signedIn = false;
  @override
  LoginState createState() => new LoginState();
}

//class _LoginData {
//  String email = "";
//  String password = "";
//}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
//  _LoginData _data = new _LoginData();
  Authentication auth = new Authentication();
  @override
  Widget build(BuildContext context) {
    auth.googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) async {
      if (account != null) {
        Dashboard.name = account.displayName;
        Dashboard.email = account.email;
        Navigator.of(context).pushReplacementNamed("/dashboard");
      }
    });
    return new Scaffold(
      backgroundColor: Colors.white,
      body: Container (
        padding: EdgeInsets.only(left: 24.0, right: 24.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              SizedBox(height: 12.0),
              Text (
                'TutorED',
                style: new TextStyle(
                  color: const Color(0xFF167F67),
                  fontSize: 32.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.0),
//              TextFormField(
//                keyboardType: TextInputType.emailAddress,
//                autofocus: false,
//                initialValue: _data.email,
//                decoration: InputDecoration(
//                  hintText: 'Email',
//                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//                ),
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return 'Enter your email';
//                  }
//                },
//                onSaved: (String value) {
//                  this._data.email = value;
//                },
//              ),
//              SizedBox(height: 8.0),
//              TextFormField(
//                autofocus: false,
//                obscureText: true,
//                initialValue: _data.password,
//                decoration: InputDecoration(
//                  hintText: 'Password',
//                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
//                ),
//                validator: (value) {
//                  if (value.isEmpty) {
//                    return 'Enter your password';
//                  }
//                },
//                onSaved: (String value) {
//                  this._data.password = value;
//                },
//              ),
//              SizedBox(height: 36.0),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
//                  onPressed: () {
//                    if (_formKey.currentState.validate()) {
//                      _formKey.currentState.save();
//                      validateLogin(context, _data.email, _data.password);
//                    }
//                  },
                  onPressed: () => auth.signIn()
                      .then((FirebaseUser user) {
                        Dashboard.name = user.displayName;
                        Dashboard.email = user.email;
                        Navigator.of(context).pushReplacementNamed("/dashboard");
                      })
                      .catchError((e) => print(e)),
                  padding: EdgeInsets.all(12),
                  color: const Color(0xFF02BB9F),
                  child: Text('Log In', style: TextStyle(color: Colors.white)),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.symmetric(vertical: 4.0),
//                child: RaisedButton(
//                  shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(24),
//                  ),
//                  onPressed: () => auth.signOut(),
//                  padding: EdgeInsets.all(12),
//                  color: const Color(0xFF02BB9F),
//                  child: Text('Sign out', style: TextStyle(color: Colors.white)),
//                ),
//              ),
//              FlatButton(
//                child: Text(
//                  'Forgot password?',
//                  style: TextStyle(color: Colors.black54),
//                ),
//                onPressed: () {},
//              ),
            ],
          ),
        ),
      )
    );
  }
}