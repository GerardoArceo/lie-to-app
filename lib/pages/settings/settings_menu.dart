import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/pages/settings/history_page.dart';
import 'package:lie_to_app_2/pages/settings/stats_page.dart';
import 'package:lie_to_app_2/providers/sign_in.dart';
import 'package:lie_to_app_2/utils/utils.dart' as utils;
import 'package:lie_to_app_2/utils/bluetooth.dart' as bluetooth;
import 'package:lie_to_app_2/utils/utils.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background(2),
        ListView(
          children: <Widget>[
            _title(),
            _roundedButtons(context),
            // _test(context)
          ],
        ),
      ]
    );
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text('Ajustes', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Text('Configura Lie to App a tu gusto', style: TextStyle(color: Colors.white, fontSize: 18.0))
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
            _gadgetButton(context),
            _accountButton(context),
          ]
        ),
        TableRow(
          children: [
            _historyButton(context),
            _statsButton(context),
          ]
        ),
        TableRow(
          children: [
            _infoButton(context),
            _settingsButton(context),
          ]
        ),
      ],
    );
  }
  
  Widget _gadgetButton(context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    return StreamBuilder(
      stream: appBloc.state.bluetoothConected,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.hasData && snapshot.data == true) {
          return RoundedButton(() => bluetooth.disconnectGadget(context), Colors.blueAccent, icon: Icons.settings_bluetooth, text: 'Desconectar gadget');
        } else {
          return RoundedButton(() => bluetooth.connectGadget(context), Colors.blueAccent, icon: Icons.bluetooth_disabled, text: 'Conectar gadget');
        }
      },
    );
  }

  Widget _accountButton(context) {
    const _color = Color.fromRGBO(194, 126, 158, 1.0);

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        if (snapshot.hasData) {
          return RoundedButton(
              () => utils.showNiceDialog(context, 'Sesión activa', 'Hola ${snapshot.data.displayName}, en este momento tienes una sesión activa', () => Provider.of<GoogleSignInProvider>(context, listen: false).signOutGoogle(), 'Cerrar Sesión'),
              _color,
              text: '${snapshot.data.displayName}',
              backgroundImage: NetworkImage(snapshot.data.photoURL!),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return RoundedButton((){},_color, icon: Icons.radio_button_checked, text: 'Cargando...');
        } else if (snapshot.hasError) { 
          return RoundedButton((){},_color, icon: Icons.all_inclusive_rounded, text: 'Error');
        } else {
          return RoundedButton(
            () => Provider.of<GoogleSignInProvider>(context, listen: false).signInWithGoogle(),
            _color, 
            icon: Icons.account_box, 
            text: 'Iniciar Sesión'
          );
        }
      },
    );
  }

  Widget _historyButton(BuildContext context) {
    const _color = Color.fromRGBO(255, 156, 99, 1.0);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        Function f;
        if (snapshot.hasData) {
          f = () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryPage(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return RoundedButton((){},_color, icon: Icons.radio_button_checked, text: 'Cargando...');
        } else if (snapshot.hasError) { 
          return RoundedButton((){},_color, icon: Icons.all_inclusive_rounded, text: 'Error');
        } else {
          f = () => utils.showNiceDialog(context, 'Oh, no', 'Necesitas iniciar sesión para utilizar esta función' , () => Provider.of<GoogleSignInProvider>(context, listen: false).signInWithGoogle(), 'Iniciar Sesión');
        }
        return RoundedButton(f, _color, icon: Icons.book, text: 'Historial');
      },
    );
  }

  Widget _statsButton(BuildContext context) {
    const _color = Color.fromRGBO(124, 188, 153, 1.0);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
        Function f;
        if (snapshot.hasData) {
          f = () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StatsPage(),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return RoundedButton((){},_color, icon: Icons.radio_button_checked, text: 'Cargando...');
        } else if (snapshot.hasError) { 
          return RoundedButton((){},_color, icon: Icons.all_inclusive_rounded, text: 'Error');
        } else {
          f = () => utils.showNiceDialog(context, 'Oh, no', 'Necesitas iniciar sesión para utilizar esta función' , () => Provider.of<GoogleSignInProvider>(context, listen: false).signInWithGoogle(), 'Iniciar Sesión');
        }
        return RoundedButton(f, _color, icon: Icons.pie_chart_outlined, text: 'Estadísticas');
      },
    );
  }

  Widget _infoButton(context) {
    const _color = Color.fromRGBO(255, 100, 87, 1.0);
    return RoundedButton(
      () => utils.showInfoDialog(context), 
      _color, 
      icon: Icons.perm_device_information, 
      text: 'Información'
    );
  }

  Widget _settingsButton(context) {
    const _color = Color.fromRGBO(97, 120, 140, 1.0);
    return RoundedButton(
      () => utils.showNiceDialog(context, 'Lie to App', 'www.gerardoarceo.com' , () => {}, 'Gracias por existir'), 
      _color,
      icon: Icons.settings_applications, 
      text: 'Configuración'
    );
  }

  void setState(Null Function() param0) {}

}
