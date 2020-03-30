import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/big_button.dart';
import 'package:lie_to_app/src/widgets/rounded_button.dart';

class HomeMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background1(),
        ListView(
          children: <Widget>[
            _title(),
            BigButton(() => Navigator.pushNamed(context, 'diagnosis'), 'assets/img/ai.png', 'Detectar mentiras'),
            _roundedButtons(context),
          ],
        ),
      ],
    ); 
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Lie to App', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('El poder de la verdad en tu bolsillo', style: TextStyle(color: Colors.white, fontSize: 18.0))
          ],
        ),
      ),
    );
  }

  Widget _roundedButtons(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            RoundedButton(() => Navigator.pushReplacementNamed(context, 'info'), Colors.blue, icon: Icons.info_outline, text: '¿Lie to App?'),
            RoundedButton(() => Navigator.pushReplacementNamed(context, 'tutorial'), Color.fromRGBO(236, 98, 188, 1.0), icon: Icons.live_help, text: 'Tutorial'),
          ]
        ),
      ],
    );
  }

}
