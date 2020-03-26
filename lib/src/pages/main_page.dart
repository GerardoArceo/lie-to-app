import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'games/games_menu.dart';
import 'home/home_menu.dart';
import 'settings/settings_menu.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final prefs = new UserPrefs();

  List<Container> _menus = [
    Container(child: HomeMenu()),
    Container(child: GamesMenu()),
    Container(child: SettingsMenu()),
  ];

  Widget liquid;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    _initStreams();

    if (liquid == null) {
      liquid = LiquidSwipe(
        pages: _menus,
        initialPage: prefs.indexMenu,
        waveType: WaveType.circularReveal,
        onPageChangeCallback: (c){setState(() {_currentIndex = c;});},
        currentUpdateTypeCallback: (c){},
      );
    }

    return Scaffold(
      body:Stack(
        children: <Widget>[
          liquid,
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
  }

  Widget _indicator(BuildContext context) {
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.bluetoothStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        print('BLUETUT');
        print(snapshot.data);
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
        onTap: (int index) async {

          liquid = _menus[index];
          _currentIndex = index;
          setState(() {});
          await new Future.delayed(const Duration(milliseconds : 50));

          liquid = LiquidSwipe(
            pages: _menus,
            initialPage: _currentIndex,
            waveType: WaveType.circularReveal,
            onPageChangeCallback: (c){setState(() {_currentIndex = c;});},
            currentUpdateTypeCallback: (c){},
          );
          setState(() {});


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
