import 'package:flutter/material.dart';
import 'authentication.dart';
import 'profile.dart';
import 'home.dart';
import 'chat.dart';

class Dashboard extends StatefulWidget {
  final String userId;
  Dashboard({Key key, @required this.userId}) : super(key: key);
  @override
  DashboardState createState() => new DashboardState(userId: userId);
}

class DashboardState extends State<Dashboard> {
  DashboardState({Key key, @required this.userId});
  Authentication auth = new Authentication();
  final String userId;
  PageController _pageController;
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

  void onItemMenuPress(Choice item) {
    if (item.title == 'Log out') {
      auth.signOut(context);
    } else if (item.title == 'Settings') {
      onPageChanged(2);
      navigationTapped(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: new Text (
            'TutorED',
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 0.04*height,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return const <Choice>[
                  const Choice(title: 'Settings', icon: Icons.settings),
                  const Choice(title: 'Log out', icon: Icons.exit_to_app),
                ].map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
      ),
      body: new PageView(
        children: [
          new Chat(),
          new Home(),
          new Profile(),
        ],
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: new BottomNavigationBar(
          onTap: navigationTapped,
          currentIndex: _page,
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
                  fontSize: 0.02*height,
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
                  fontSize: 0.02*height,
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
                  fontSize: 0.02*height,
                ),
              ))
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}