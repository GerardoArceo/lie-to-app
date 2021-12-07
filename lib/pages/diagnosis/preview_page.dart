import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:lie_to_app_2/pages/diagnosis/sound_player.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/big_button.dart';
import 'package:lie_to_app_2/utils/utils.dart' as utils;
import 'package:lie_to_app_2/widgets/rounded_button.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, this.mode}) : super(key: key);

  final String? mode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          background(3, opacity: 0.8),
          ListView(
            children: <Widget>[
              _title(),
              _bigButtonWidget(context),
              _bpmResultsWidget(context),
              const SizedBox(height: 15.0),
              _eyeTrackingResultsWidget(context),
              const SimplePlayback(),
              _hiddenButtons(context),
            ],
          ),
          backButton(context),
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
          Text('Lecturas', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 20.0,),
          Text('Estás muy cerca de la verdad', style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }

  Widget _bigButtonWidget(context) {
    final appBloc = BlocProvider.of<AppBloc>(context);

    return StreamBuilder(
      stream: appBloc.state.isLoading,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.data == true) {
          return BigButton(() => {}, 'assets/img/ai.png', 'Calculando diagnóstico...', animate: true,);
        } else {
          return Column(
            children: <Widget>[
              BigButton(() => _sendDiagnosis(context), 'assets/img/ai.png', 'Enviar Lecturas'),
            ],
          );
        }
      },
    );
  }

  Widget _bpmResultsWidget(context) {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

    return StreamBuilder(
      stream: diagnosisBloc.state.bpmResults,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
        return Text(
          (snapshot.data != null ? snapshot.data!.length.toString() : '0') + ' muestras de pulso recolectadas',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          textAlign: TextAlign.center,
        );
      }
    );
  }

  Widget _eyeTrackingResultsWidget(context) {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

    return StreamBuilder(
      stream: diagnosisBloc.state.eyeTrackingResults,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
        return Text(
          (snapshot.data != null ? snapshot.data!.length.toString() : '0') + ' muestras oculares recolectadas',
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          textAlign: TextAlign.center,
        );
      }
    );
  }
  
  _sendDiagnosis(BuildContext context, {bool? fixedAnswer}) async {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    appBloc.add( SetLoadingState(true) );

    try {
      final audioPath = diagnosisBloc.state.audioPathValue;
      final bpmResults = diagnosisBloc.state.bpmResultsValue ?? [];
      final eyeTrackingResults = diagnosisBloc.state.eyeTrackingResultsValue ?? [];
      final res = await CloudApiProvider().sendDiagnosis(audioPath, bpmResults, eyeTrackingResults, mode ?? 'diagnosis', fixedAnswer: fixedAnswer);
      appBloc.add( SetLoadingState(false) );

      switch (mode) {
        case 'calibration':
          Navigator.pushNamed(context, 'diagnosis');
          if (res == null) {
            utils.showNiceDialog(context, 'Lie to app', 'Error al calibrar el gadget' , () => {}, '');
          } else {
            utils.showNiceDialog(context, 'Lie to app', 'Calibración de gadget realizada correctamente' , () => {}, '');
          }
          break;
        case 'testing':
          Navigator.pushNamed(context, 'diagnosis');
          utils.showNiceDialog(context, 'Lie to app', 'Prueba realizada correctamente' , () => {}, '');
          break;
        case 'trainingTruth':
        case 'trainingLie':
          Navigator.pushNamed(context, 'diagnosis');
          if (res == null) {
            utils.showNiceDialog(context, 'Lie to app', 'Error al guardar datos de entrenamiento' , () => {}, '');
          } else {
            utils.showNiceDialog(context, 'Lie to app', 'Datos de entrenamiento guardados correctamente' , () => {}, '');
          }
          break;
        case 'diagnosis':
          Navigator.pushNamed(context, 'results', arguments: res);
          break;
      }
    } catch (e) {
      appBloc.add( SetLoadingState(false) );
    }
  }

  Widget _hiddenButtons(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            RoundedButton(() {
              _sendDiagnosis(context, fixedAnswer: true);
            }, Colors.transparent, invisible: true,),
            RoundedButton(() {
              _sendDiagnosis(context, fixedAnswer: false);
            }, Colors.transparent, invisible: true,),
          ]
        )
      ],
    );
  }
}
