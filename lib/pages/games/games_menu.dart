import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app_2/pages/games/questions_page.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';

class GamesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background2(),
        ListView(
          children: <Widget>[
            _title(),
            _roundedButtons(context),
          ],
        ),
      ]
    );
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text('Juegos de la verdad', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('Saber la verdad es divertido', style: TextStyle(color: Colors.white, fontSize: 18.0))
          ],
        ),
      ),
    );
  }

  Widget _roundedButtons(context) {
    return Table(
      children: [
        TableRow(
          children: [
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 1))), 
              Color.fromRGBO(85, 190, 150, 1.0), icon: Icons.question_answer, text: 'Verdad o reto'
            ),
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 2))), 
              Color.fromRGBO(96, 102, 199, 1.0), icon: Icons.fingerprint, text: 'Crímenes'
            ),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 3))), 
              Color.fromRGBO(255, 143, 0, 1.0), icon: Icons.account_box, text: 'Preguntas en familia'
            ),
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 4))), 
              Color.fromRGBO(245, 5, 78, 1.0), icon: Icons.favorite, text: 'Preguntas en pareja'
            ),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 5))), 
              Color.fromRGBO(240, 128, 128, 1.0), icon: Icons.people, text: 'Preguntas generales'
            ),
            RoundedButton(
              () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuestionsPage(mode: 6))), 
              Color.fromRGBO(247, 149, 195, 1.0), icon: Icons.local_play, text: 'Preguntas filosóficas'
            ),
          ]
        ),
      ],
    );
  }

}
