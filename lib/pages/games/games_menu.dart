import 'dart:ui';

import 'package:flutter/material.dart';
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Juegos de la verdad', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('Saber la verdad es divertido', style: TextStyle(color: Colors.white, fontSize: 18.0))
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
            RoundedButton(() => {}, Color.fromRGBO(96, 102, 199, 1.0), icon: Icons.fingerprint, text: 'Crímenes'),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(() => {}, Color.fromRGBO(255, 143, 0, 1.0), icon: Icons.account_box, text: 'Preguntas en familia'),
            RoundedButton(() => {}, Color.fromRGBO(245, 5, 78, 1.0), icon: Icons.favorite, text: 'Preguntas en pareja'),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(() => {}, Color.fromRGBO(254, 115, 108, 1.0), icon: Icons.people, text: 'Modo fiesta'),
            RoundedButton(() => {}, Color.fromRGBO(229, 80, 145, 1.0), icon: Icons.local_play, text: 'Modo random'),
          ]
        ),
      ],
    );
  }

}
