import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'login.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TutorED',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColor: const Color(0xFF02BB9F),
        primaryColorDark: const Color(0xFF167F67),
        accentColor: const Color(0xFFFFAD32),
        fontFamily: 'Roboto'
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/': return new Transition(
            builder: (_) => new Login(),
            settings: settings,
          );
          case '/dashboard': return new Transition(
            builder: (_) => new Dashboard(),
            settings: settings,
          );
        }
        assert(false);
      }
    );
  }
}

class Transition<T> extends MaterialPageRoute<T> {
  Transition({ WidgetBuilder builder, RouteSettings settings })
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
        if (settings.isInitialRoute)
          return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}