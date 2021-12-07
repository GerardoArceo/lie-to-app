import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/pages/settings/settings_menu.dart';

import 'games/games_menu.dart';
import 'home/home_menu.dart';

final _menus = [
  const HomeMenu(),
  const GamesMenu(),
  const SettingsMenu()
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _menus.length,
            itemBuilder: (ctx, i) => _menus[i],
          ),
          _indicator(context),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(context),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Widget _indicator(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return StreamBuilder(
      stream: appBloc.state.bluetoothConected,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: snapshot.hasData && snapshot.data == true ? const Icon(Icons.bluetooth_connected, color: Colors.white) : const Icon(Icons.bluetooth_disabled, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _bottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: const Color.fromRGBO(55, 57, 84, 1.0),
        primaryColor: Colors.pinkAccent,
        textTheme: Theme.of(context).textTheme.copyWith(
          caption: const TextStyle(color: Color.fromRGBO(116, 117, 152, 1.0))
        )
      ),
      child: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        fixedColor: Colors.pink,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem (
            icon: Icon(Icons.home, size: 30.0,),
            label: ''
          ),
          BottomNavigationBarItem (
            icon: Icon(Icons.apps, size: 30.0,),
            label: ''
          ),
          BottomNavigationBarItem (
            icon: Icon(Icons.settings, size: 30.0,),
            label: ''
          )
        ]
      )
    );
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

}
