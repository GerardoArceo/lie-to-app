import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/audio_recorder.dart';
import 'package:lie_to_app/src/widgets/big_button.dart';

class DiagnosisPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final blocController = BlocProvider.of(context);

    return Scaffold(
      body:Stack(
        children: <Widget>[
          background4(),
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              child: backButton(context, callback: () => Navigator.pushNamed(context, 'main')),
            ),
          ),
          Column(
            children: <Widget>[
              _title(),
              // Expanded(child: Container()),
              StreamBuilder(
                stream: blocController.loadingStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == true) {
                    return BigButton(() => _stopDiagnosis(context), 'assets/img/ai.png', 'Finalizar', animate: true,);
                  } else {
                    return Column(
                      children: <Widget>[
                        BigButton(() => _startDiagnosis(context), 'assets/img/ai.png', 'Empezar'),
                        _body(context),
                      ],
                    );
                  }
                },
              ),
              AudioRecorder(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20.0,),
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
          _text = 'Lentes gadget preparados para el diagnóstico';
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

  _startDiagnosis(BuildContext context) async {
    final blocController = BlocProvider.of(context);

    blocController.setRecordState('start');

    blocController.setLoadingState(true);
  }

  _stopDiagnosis(BuildContext context) {
    final blocController = BlocProvider.of(context);

    blocController.setRecordState('stop');
    
    Navigator.pushNamed(context, 'preview');

    blocController.setLoadingState(false);
  }
}
