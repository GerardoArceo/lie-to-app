import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';
import 'package:lie_to_app/src/providers/cloud_api.dart';
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/rounded_button.dart';

class ResultsPage extends StatefulWidget {

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final prefs = new UserPrefs();

  bool _resultSent = false;
  String _retroText = 'Ayúdanos a mejorar con tu retroalimentación';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body:Stack(
        children: <Widget>[
          background6(),
          ListView(
            children: <Widget>[
              _title(),
              _body(context, args),
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
            Text('Resultado', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 40.0,),
          ],
        ),
      ),
    );
  }

    Widget _body(BuildContext context, Map result) {
      final blocController = BlocProvider.of(context);

      final titleStyle = TextStyle(fontSize: 60.0, color: Colors.white);
      final textStyle = TextStyle(fontSize: 15.0, color: Colors.white, fontStyle: FontStyle.italic);
      
      if (result == null || result['ok'] == null || result['ok'] == false) {
        return Container(
          margin: EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Text('Hubo un error en el análisis :(', style: titleStyle, textAlign: TextAlign.center,),
            ],
          ),
        ); 
      }

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(result['result'], style: titleStyle, textAlign: TextAlign.center,),
          Text('Probabilidad de diagnóstico correcto: ' + result['interval'], style: textStyle, textAlign: TextAlign.center,),
          SizedBox(height: 60,),

          Table(
            children: [
              TableRow(
                children: [
                  RoundedButton(() => Navigator.pushNamed(context, 'main'), Colors.blueAccent, icon: Icons.home, text: 'Regresar al menú'),
                  RoundedButton(() => Navigator.pushNamed(context, 'diagnosis'), Colors.teal, icon: Icons.restore_page, text: 'Nuevo diagnóstico'),
                ]
              ),
            ],
          ),
          SizedBox(height: 20,),

          StreamBuilder(
            stream: blocController.sesionStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot == null || snapshot.data == false || prefs.uid == null) return Container();
              return Column(
                children: <Widget>[
                  Text(_retroText, style: textStyle, textAlign: TextAlign.center,),
                  StreamBuilder(
                    stream: blocController.loadingStream,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if (snapshot.data == true) {
                        return Column(children: [SizedBox(height: 20,), CircularProgressIndicator()]);
                      } else {
                        if (_resultSent == true) {
                          return Container();
                        }
                        return Table(
                          children: [
                            TableRow(
                              children: [
                                RoundedButton(() => _sendRetroalimentation(context, false), Colors.redAccent, icon: Icons.mood_bad, text: 'Falló'),
                                RoundedButton(() => _sendRetroalimentation(context, true), Colors.green, icon: Icons.mood, text: 'Acertó'),
                              ]
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ]
              );
            }
          ),
        
        ],
      ),
    );
  }

  _sendRetroalimentation(BuildContext context, bool result) async {
    final blocController = BlocProvider.of(context);
    blocController.setLoadingState(true);
    print(prefs.uid.toString());
    final results = {
      'uid': prefs.uid.toString(),
      'result': result.toString()
    };
    final r = await CloudApiProvider().sendRetroalimentation(results);
    if (r != null && r['ok'] != null && r['ok'] == true) {
      _resultSent = true;
      _retroText = 'Gracias por tu retroalimentación';
      setState(() {});
    }
    blocController.setLoadingState(false);
  }
}
