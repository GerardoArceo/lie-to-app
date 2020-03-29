import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lie_to_app/src/pages/main_page.dart';

class TutorialPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _page1(),
          _page2(),
          MainPage()
        ],
      )
    );
  }

  Widget _page1() {
    final titleStyle = TextStyle(color: Colors.white, fontSize: 60.0);
    return Stack(
      children: <Widget>[
        _backgroundColor(),
        _backgroundImage(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              Text('TUTORIAL', style: titleStyle),
              Expanded(child: Container()),
              _arrow(),
              SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _page2() {
    final titleStyle = TextStyle(color: Colors.white, fontSize: 20.0);

    return Stack(
      children: <Widget>[
        _backgroundColor(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              Text('Lie to App, proximamente...', style: titleStyle),
              Expanded(child: Container()),
              _arrow(),
              SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _backgroundColor() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(108, 192, 218, 1)
    );
  }

  Widget _backgroundImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage('assets/img/scroll.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _arrow() {
    final textStyle = TextStyle(fontSize: 15.0, color: Colors.white );
    return Column(
      children: <Widget>[
        Text('Desliza hacia abajo', style: textStyle),
        Pulse(
          infinite: true,
          child: Icon(Icons.keyboard_arrow_down, size: 70.0, color: Colors.white,)
        ),
      ]
    );
  }

}