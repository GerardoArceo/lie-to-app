import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';

showSettingsDialog(BuildContext context) {
  const titleStyle = TextStyle(fontSize: 30.0, color: Colors.white);
  const buttonStyle = TextStyle(fontSize: 15.0, color: Color.fromRGBO(241,125, 160, 1));
  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    backgroundColor: Colors.white,
    padding: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
  );

  showGeneralDialog(
    barrierColor: Colors.black.withOpacity(0.5),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: AlertDialog(
            shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0)
            ),
            backgroundColor: const Color.fromRGBO(241,125, 170, 0.8),
            title: Row(
              children: const  <Widget>[
                Icon(Icons.error_outline, color: Colors.white, size: 50.0),
                SizedBox(width: 10,),
                Text('Ajustes', style: titleStyle,),
              ],
            ),
            content: const SettingsPage(),
            actions: <Widget>[
              TextButton(
                style: flatButtonStyle,
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "OK",
                  style: buttonStyle,
                ),
              ),
            ],
          ),
        ),  
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    }
  );
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    const titleStyle = TextStyle(fontSize: 20.0, color: Colors.white);

    return SizedBox(
      height: 200,
      child: Column(
      children: <Widget>[
          const Text('Servidor', style: titleStyle,),
          const SizedBox(height: 10,),
          serversList(),
          const SizedBox(height: 10,),
          const Text('Diagnóstico Lite', style: titleStyle,),
          const SizedBox(height: 10,),
          switchButton(),
        ]
      )
    );
  }

  Widget serversList() {
    const titleStyle = TextStyle(fontSize: 15.0, color: Colors.white);

    final appBloc = BlocProvider.of<AppBloc>(context);

    String dropdownValue = appBloc.state.apiURLValue!;

    return DropdownButton<String>(
      dropdownColor: const Color.fromRGBO(241,125, 170, 1),
      value: dropdownValue,
      elevation: 16,
      style: const TextStyle(color: Colors.blueAccent),
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          appBloc.add(SetApiURL(newValue!));
          dropdownValue = newValue;
        });
      },
      items: <String>['Gera', 'Lili', 'LS']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: titleStyle,),
        );
      }).toList(),
    );
  }

  Widget switchButton() {
    final appBloc = BlocProvider.of<AppBloc>(context);

    bool isSwitched = appBloc.state.isDiagnosisLite!;

    return Switch(
      value: isSwitched,
      onChanged: (bool? value){
        setState(() {
          appBloc.add(SetDiagnosisLiteState(value!));
          isSwitched = value;
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }
 
}
