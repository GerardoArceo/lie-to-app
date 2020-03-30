import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/providers/cloud_api.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/audio_player.dart';
import 'package:lie_to_app/src/widgets/big_button.dart';
import 'package:path_provider/path_provider.dart';

class PreviewPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final blocController = BlocProvider.of(context);

    return Scaffold(
      body:Stack(
        children: <Widget>[
          background5(),
          ListView(
            children: <Widget>[
              _title(),
              AudioPlayer(),
              StreamBuilder(
                stream: blocController.loadingStream ,
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
            ],
          ),
          backButton(context),
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
            Text('Lecturas', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('Estás muy cerca de la verdad', style: TextStyle(color: Colors.white, fontSize: 18.0))
          ],
        ),
      ),
    );
  }

  Future<Uint8List> makeBuffer() async {
    Directory tempDir = await getTemporaryDirectory();
    String path = '${tempDir.path}/sound.aac';
    try {
      File file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      return contents;
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  _sendDiagnosis(BuildContext context) async {
    final blocController = BlocProvider.of(context);
    blocController.setLoadingState(true);
    final results = {
      'voice_signal': (await makeBuffer()).toString(),
      'eyes_movements': 'HOLO'
    };
    final res = await CloudApiProvider().sendDiagnosis(results);
    blocController.setLoadingState(false);
    Navigator.pushNamed(context, 'results', arguments: res);
  }
}
