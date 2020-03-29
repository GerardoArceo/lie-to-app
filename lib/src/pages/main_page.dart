import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';

import 'games/games_menu.dart';
import 'home/home_menu.dart';
import 'settings/settings_menu.dart';

final _menus = [
  HomeMenu(),
  GamesMenu(),
  SettingsMenu(),
];

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final prefs = new UserPrefs();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    _initStreams();

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _menus[_currentIndex],
          _indicator(context),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  _initStreams() {
    final blocController = BlocProvider.of(context);

    if (prefs.uid == null) {
      blocController.setSessionState('inactive');
    } else {
      blocController.setSessionState('active');
    }

    blocController.setLoadingState(false);
    blocController.setRecordState('stop');
  }

  Widget _indicator(BuildContext context) {
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.bluetoothStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: snapshot.hasData && snapshot.data ? Icon(Icons.bluetooth_connected, color: Colors.white) : Icon(Icons.bluetooth_disabled, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color.fromRGBO(55, 57, 84, 1.0),
        primaryColor: Colors.pinkAccent,
        textTheme: Theme.of(context).textTheme.copyWith(
          caption: TextStyle(color: Color.fromRGBO(116, 117, 152, 1.0))
        )
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.pink,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem (
            icon: Icon(Icons.home, size: 30.0,),
            title: Container()
          ),
          BottomNavigationBarItem (
            icon: Icon(Icons.apps, size: 30.0,),
            title: Container()
          ),
          BottomNavigationBarItem (
            icon: Icon(Icons.settings, size: 30.0,),
            title: Container()
          )
        ]
      )
    );
  }

}
