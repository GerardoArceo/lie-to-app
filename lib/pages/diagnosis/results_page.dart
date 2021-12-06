import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  bool _resultSent = false;
  String _retroText = 'Ayúdanos a mejorar con tu retroalimentación';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SizedBox(height: 20.0,),
          Text('Resultado', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 40.0,),
        ],
      ),
    );
  }

    Widget _body(BuildContext context, Map result) {
      final appBloc = BlocProvider.of<AppBloc>(context);

      const titleStyle = TextStyle(fontSize: 60.0, color: Colors.white);
      const textStyle = TextStyle(fontSize: 15.0, color: Colors.white, fontStyle: FontStyle.italic);
      
      if (result == null || result['ok'] == null || result['ok'] == false) {
        return Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: const <Widget>[
              Text('Hubo un error en el análisis :(', style: titleStyle, textAlign: TextAlign.center,),
            ],
          ),
        ); 
      }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(result['final_result'] ? 'Verdad' : 'Mentira', style: titleStyle, textAlign: TextAlign.center,),
          Text('Probabilidad de diagnóstico correcto: ' + result['hit_probability'], style: textStyle, textAlign: TextAlign.center,),
          const SizedBox(height: 60,),

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
          const SizedBox(height: 20,),

          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.hasData == false) return Container();
              return Column(
                children: <Widget>[
                  Text(_retroText, style: textStyle, textAlign: TextAlign.center,),
                  StreamBuilder(
                    stream: appBloc.state.isLoading,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if (snapshot.data == true) {
                        return Column(children: const [SizedBox(height: 20,), CircularProgressIndicator()]);
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
    final appBloc = BlocProvider.of<AppBloc>(context);
    appBloc.add( SetLoadingState(true) );
    final r = await CloudApiProvider().sendPostRequest({'was_right': result.toString()}, 'retroalimentation');
    if (r != null && r['ok'] != null && r['ok'] == true) {
      _resultSent = true;
      _retroText = 'Gracias por tu retroalimentación';
      setState(() {});
    }
    appBloc.add( SetLoadingState(false) );
  }
}
