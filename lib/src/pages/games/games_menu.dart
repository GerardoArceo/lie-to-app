import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/rounded_button.dart';

class GamesMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background2(),
        Column(
          children: <Widget>[
            _title(),
            _roundedButtons(),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Juegos de la verdad', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('Ahora saber la verdad es más divertido', style: TextStyle(color: Colors.white, fontSize: 18.0))
          ],
        ),
      ),
    );
  }

  Widget _roundedButtons() {
    return Table(
      children: [
        TableRow(
          children: [
            RoundedButton(() => {}, Color.fromRGBO(85, 190, 150, 1.0), icon: Icons.question_answer, text: 'Verdad o reto'),
            RoundedButton(() => {}, Colors.deepPurpleAccent, icon: Icons.adjust, text: 'Ruleta Rusa'),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(() => {}, Colors.amber, icon: Icons.account_box, text: 'Preguntas en familia'),
            RoundedButton(() => {}, Colors.red, icon: Icons.favorite, text: 'Preguntas en pareja'),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(() => {}, Colors.lightGreen, icon: Icons.people, text: 'Modo fiesta'),
            RoundedButton(() => {}, Colors.cyan, icon: Icons.local_play, text: 'Modo random'),
          ]
        ),
      ],
    );
  }

}
