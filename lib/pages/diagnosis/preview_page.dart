import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:lie_to_app_2/pages/diagnosis/sound_player.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/big_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:lie_to_app_2/utils/utils.dart' as utils;

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, this.mode}) : super(key: key);

  final dynamic mode;

  @override
  Widget build(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

    return Scaffold(
      body:Stack(
        children: <Widget>[
          background5(),
          ListView(
            children: <Widget>[
              _title(),
              StreamBuilder(
                stream: appBloc.state.isLoading,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if (snapshot.data == true) {
                    return BigButton(() => {}, 'assets/img/ai.png', 'Enviando Datos...', animate: true,);
                  } else {
                    return Column(
                      children: <Widget>[
                        BigButton(() => _sendDiagnosis(context), 'assets/img/ai.png', 'Enviar Lecturas'),
                      ],
                    );
                  }
                },
              ),
              StreamBuilder(
                stream: diagnosisBloc.state.bpm,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  return Text(
                    snapshot.data != null ? snapshot.data.toString() + ' latidos por minuto' : '-',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                }
              ),
              const SizedBox(
                  width: 200.0,
                  height: 15.0
              ),
              StreamBuilder(
                stream: diagnosisBloc.state.eyeTrackingResults,
                builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot){
                  return Text(
                    (snapshot.data != null ? snapshot.data!.length.toString() : '0') + ' muestras oculares recolectadas',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                }
              ),
              SimplePlayback()
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

  Future<Uint8List?> makeBuffer() async {
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/sound.aac';
    try {
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      return null;
    }
  }
  
  _sendDiagnosis(BuildContext context) async {
    final appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.add( SetLoadingState(true) );

    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    try {
      final res = await CloudApiProvider().sendDiagnosis(diagnosisBloc.state.audioPathValue, diagnosisBloc.state.bpmResultsValue ?? [], diagnosisBloc.state.eyeTrackingResultsValue ?? [], mode);
      appBloc.add( SetLoadingState(false) );
      if (mode == 'calibration') {
        Navigator.pushNamed(context, 'diagnosis');
        utils.showNiceDialog(context, 'Lie to app', 'Calibración de gadget realizada correctamente' , () => {}, '');
      } else if (mode == 'testing') {
        Navigator.pushNamed(context, 'diagnosis');
        utils.showNiceDialog(context, 'Lie to app', 'Prueba realizada correctamente' , () => {}, '');
      } else if (mode == 'trainingTruth' || mode == 'trainingLie' || mode == 'testing') {
        Navigator.pushNamed(context, 'diagnosis');
        if (res == null) {
          utils.showNiceDialog(context, 'Lie to app', 'Error al guardar datos de entrenamiento' , () => {}, '');
        } else {
          utils.showNiceDialog(context, 'Lie to app', 'Datos de entrenamiento guardados correctamente' , () => {}, '');
        }
      } else {
        Navigator.pushNamed(context, 'results', arguments: res);
      }
    } catch (e) {
      appBloc.add( SetLoadingState(false) );
    }
  }
}
