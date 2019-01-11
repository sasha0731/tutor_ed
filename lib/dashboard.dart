import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile.dart';
import 'login.dart';
import 'home.dart';
import 'chat.dart';

class Dashboard extends StatefulWidget {
  static String name;
  static String email;

  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  Authentication auth = new Authentication();
  static PageController _pageController;
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(40), // here the desired height
          child: AppBar(
              title: new Text (
                'TutorED',
                style: new TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 24.0,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      'Logout'
                  ),
                  onPressed: () {
                    auth.signOut();
                    Navigator.of(context).pushReplacementNamed("/");
                  },
                )
              ]
          )
      ),
      body: new PageView(
        children: [
          new Chat(),
          new Home(),
          new Profile(),
        ],
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFF167F67),
        ),
        child: new BottomNavigationBar(

          items: [
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.chat_bubble,
                  color: const Color(0xFFFFFFFF),
                ),
                title: new Text(
                  "Chat",
                  style: new TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: const Color(0xFFFFFFFF),
                ),
                title: new Text(
                  "Home",
                  style: new TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                )),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.person,
                  color: const Color(0xFFFFFFFF),
                ),
                title: new Text(
                  "Profile",
                  style: new TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                ))
          ],
          onTap: navigationTapped,
          currentIndex: _page,

        ),
      ),
    );
  }
}