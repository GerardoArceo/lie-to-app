import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lie_to_app_2/pages/main_page.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({Key? key}) : super(key: key);


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
    const titleStyle = TextStyle(color: Colors.white, fontSize: 60.0);
    return Stack(
      children: <Widget>[
        _backgroundColor(),
        _backgroundImage(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              const Text('TUTORIAL', style: titleStyle),
              Expanded(child: Container()),
              _arrow(),
              const SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _page2() {
    const titleStyle = TextStyle(color: Colors.white, fontSize: 20.0);

    return Stack(
      children: <Widget>[
        _backgroundColor(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              const Text('Lie to App, proximamente...', style: titleStyle),
              Expanded(child: Container()),
              _arrow(),
              const SizedBox(height: 20.0,),
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
      color: const Color.fromRGBO(108, 192, 218, 1)
    );
  }

  Widget _backgroundImage() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage('assets/img/scroll.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _arrow() {
    const textStyle = TextStyle(fontSize: 15.0, color: Colors.white );
    return Column(
      children: <Widget>[
        const Text('Desliza hacia abajo', style: textStyle),
        Pulse(
          infinite: true,
          child: const Icon(Icons.keyboard_arrow_down, size: 70.0, color: Colors.white,)
        ),
      ]
    );
  }

}