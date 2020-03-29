import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';
import 'package:lie_to_app/src/providers/sign_in.dart';
import 'package:lie_to_app/src/utils/utils.dart' as utils;
import 'package:lie_to_app/src/utils/utils.dart';
import 'package:lie_to_app/src/widgets/rounded_button.dart';

class SettingsMenu extends StatelessWidget {

  final prefs = new UserPrefs();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background3(),
        ListView(
          children: <Widget>[
            _title(),
            _roundedButtons(context),
          ],
        ),
      ]
    );
  }

  Widget _title() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
            _settingsButton(context),
            _infoButton(context),
          ]
        ),
      ],
    );
  }

  Widget _gadgetButton(context) {
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.bluetoothStream,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
        if (snapshot.hasData && snapshot.data) {
          return RoundedButton(() => blocController.setBluetoothState(false), Colors.blueAccent, icon: Icons.settings_bluetooth, text: 'Configurar gadget');
        } else {
          return RoundedButton(() => blocController.setBluetoothState(true), Colors.blueAccent, icon: Icons.bluetooth_disabled, text: 'Conectar gadget');
        }
      },
    );
  }

  Widget _accountButton(context) {

    final blocController = BlocProvider.of(context);

    return StreamBuilder(
      stream: blocController.sesionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){        
        if (!snapshot.hasData || snapshot.data == 'inactive') {
          return RoundedButton(
            () => utils.signIn(context),
            Colors.teal, 
            icon: Icons.account_box, 
            text: 'Iniciar Sesión'
          );
        } else if (snapshot.data == 'active'){
          if (name != null && email != null && imageUrl!= null) {
            return RoundedButton(
              (){
                final callback = (){
                  blocController.setSessionState('inactive');
                  signOutGoogle();
                };
                utils.showNiceDialog(context, 'Hola $name', 'En este momento tienes una sesión iniciada con el email $email', callback, 'Cerrar Sesión');
              },
              Colors.teal,
              text: '$name',
              backgroundImage: NetworkImage(imageUrl,),
            );
          } else {
            return RoundedButton(
              () => utils.signIn(context),
              Colors.teal,
              icon: Icons.account_box, 
              text: 'Mi Cuenta',
            );
          }
        } else {
          return RoundedButton((){},Colors.teal, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
      },
    );
  }

  Widget _historyButton(BuildContext context) {
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.sesionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        Function f;
        if (!snapshot.hasData || snapshot.data == 'inactive') {
          f = () => utils.showNiceDialog(context, 'Oh, no', 'Necesitas iniciar sesión para utilizar esta función' , () => utils.signIn(context), 'Iniciar Sesión');
        } else if (snapshot.data == 'active'){
          f = () => print('HOLA MUNDO');
        } else {
          return RoundedButton((){},Colors.pinkAccent, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
        return RoundedButton(f, Colors.pinkAccent, icon: Icons.account_box, text: 'Historial');
      },
    );
  }

  Widget _statsButton(BuildContext context) {
    final blocController = BlocProvider.of(context);
    return StreamBuilder(
      stream: blocController.sesionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        Function f;
        if (!snapshot.hasData || snapshot.data == 'inactive') {
          f = () => utils.showNiceDialog(context, 'Oh, no', 'Necesitas iniciar sesión para utilizar esta función' , () => utils.signIn(context), 'Iniciar Sesión');
        } else if (snapshot.data == 'active'){
          f = () => print('HOLA MUNDO');
        } else {
          return RoundedButton((){},Colors.orange, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
        return RoundedButton(f, Colors.orange, icon: Icons.pie_chart_outlined, text: 'Estadísticas');
      },
    );
  }

  Widget _settingsButton(context) {
    return RoundedButton(
      (){
        prefs.darkTheme = !prefs.darkTheme;
        Navigator.pushNamed(context, 'main');
      },
      Colors.grey,
      icon: Icons.settings_applications, 
      text: 'Configuración'
    );
  }

  Widget _infoButton(context) {
    return RoundedButton(
      () => utils.showNiceDialog(context, 'Lie to App', 'www.gerardoarceo.com' , () => {}, 'TQM'), 
      Colors.deepOrangeAccent, 
      icon: Icons.perm_device_information, 
      text: 'Información'
    );
  }

}
