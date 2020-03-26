import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/big_button.dart';

class DiagnosisPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          background4(),
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: backButton(context),
            ),
          ),
          Column(
            children: <Widget>[
              _title(),
              Expanded(child: Container()),
              BigButton(_startDiagnosis, 'assets/img/ai.png', 'Empezar'),
              _body(context),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Diagnóstico', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('¿Listo para conocer la verdad?', style: TextStyle(color: Colors.white, fontSize: 18.0))
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final textStyle = TextStyle(fontSize: 20.0, color: Colors.white, fontStyle: FontStyle.italic);
    
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.bluetoothStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        String _text;
        if (snapshot.hasData && snapshot.data == true) {
          _text = 'Lentes gadget preparados para el diagnósticoe';
        } else {
          _text = 'IMPORTANTE: Los lentes gadget no están conectados por lo que la calidad del diagnóstico será inferior';
        }
        return Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text(_text, style: textStyle, textAlign: TextAlign.justify,),
            ],
          ),
        );
      },
    );
  }

  _startDiagnosis() {
    print('OK');
  }
}
