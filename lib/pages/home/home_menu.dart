import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/big_button.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';
import 'package:lie_to_app_2/utils/utils.dart' as utils;
import 'package:lie_to_app_2/utils/bluetooth.dart' as bluetooth;

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);

    return Stack(
      children: <Widget>[
        background(0),
        ListView(
          children: <Widget>[
            _title(),
            // BigButton(() => Navigator.pushNamed(context, 'diagnosis'), 'assets/img/ai.png', 'Detectar mentiras'),
            BigButton((){
              if (appBloc.state.isBluetoothConected == true) {
                Navigator.pushNamed(context, 'diagnosis');
              } else {
                utils.showNiceDialog(context, 'Oh, no', 'Necesitas conectar el gadget especial para poder realizar diagnósticos' , () => bluetooth.connectGadget(context), 'Conectar gadget');
              }
            }, 'assets/img/ai.png', 'Detectar mentiras'),
            _roundedButtons(context),
          ],
        ),
      ],
    ); 
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
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
            RoundedButton(() => Navigator.pushReplacementNamed(context, 'tutorial'), const Color.fromRGBO(236, 98, 188, 1.0), icon: Icons.live_help, text: 'Tutorial'),
          ]
        ),
      ],
    );
  }

}
