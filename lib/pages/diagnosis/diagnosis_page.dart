import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:lie_to_app_2/pages/diagnosis/gadget_sensors.dart';
import 'package:lie_to_app_2/pages/diagnosis/preview_page.dart';
import 'package:lie_to_app_2/pages/diagnosis/sound_recorder.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/big_button.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';

class DiagnosisPage extends StatelessWidget {
  DiagnosisPage({Key? key}) : super(key: key);
  String mode = 'diagnosis';

  @override
  Widget build(BuildContext context) {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

    return Scaffold(
      body:Stack(
        children: <Widget>[
          background4(),
          const SimpleRecorder(),
          ListView(
            children: <Widget>[
              _title(),
              StreamBuilder(
                stream: diagnosisBloc.state.diagnosisOnProgress ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == true) {
                    return BigButton(() => {
                      _stopDiagnosis(context),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewPage(mode: mode),
                        ),
                      )
                    }, 'assets/img/ai.png', 'Finalizar', animate: true,);
                  } else {
                    return Column(
                      children: <Widget>[
                        BigButton(() => _startDiagnosis(context), 'assets/img/ai.png', 'Empezar'),
                        // _body(context),
                        _calibrationButton(context),
                      ],
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: diagnosisBloc.state.diagnosisOnProgress ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == true) {
                    return const SizedBox(
                      width: 200.0,
                      height: 600.0,
                      child: GadgetSensors(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
          backButton(context, callback: () => {
            _stopDiagnosis(context),
            Navigator.pushNamed(context, 'main')
          }),
        ],
      ),
    );
  }

  Widget _title() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SizedBox(height: 20.0,),
          Text('Diagnóstico', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 20.0,),
          Text('¿Listo para conocer la verdad?', style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }

  _startDiagnosis(BuildContext context) async {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    diagnosisBloc.add( SetDiagnosisOnProgress(true) );
  }

  _stopDiagnosis(BuildContext context) {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    diagnosisBloc.add( SetDiagnosisOnProgress(false) );
  }


  Widget _calibrationButton(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);

    return Table(
      children: [
        TableRow(
          children: [
            RoundedButton(() {
               mode = 'calibration';
              _startDiagnosis(context);
            }, Color.fromRGBO(97, 120, 140, 1.0), icon: Icons.settings_applications, text: 'Calibrar gadget'),
            RoundedButton(() {
               mode = 'testing';
              _startDiagnosis(context);
            }, Color.fromRGBO(194, 126, 158, 1.0), icon: Icons.app_registration_sharp, text: 'Modo de prueba'),
          ]
        ),
        TableRow(
          children: [
            RoundedButton(() {
              mode = 'trainingTruth';
              _startDiagnosis(context);
            }, Color.fromRGBO(85, 190, 150, 1.0), icon: Icons.check_circle, text: 'Entrenar verdad'),
            RoundedButton(() {
              mode = 'trainingLie';
              _startDiagnosis(context);
            }, Color.fromRGBO(254, 115, 108, 1.0), icon: Icons.error_outline_rounded, text: 'Entrenar mentira'),
          ]
        ),
      ],
    );
  }

}