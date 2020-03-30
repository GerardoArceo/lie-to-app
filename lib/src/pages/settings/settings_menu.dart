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
            _infoButton(context),
            _settingsButton(context),
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
          Function f = () {
            blocController.setBluetoothState(false);
          };
          return RoundedButton(f, Colors.blueAccent, icon: Icons.settings_bluetooth, text: 'Configurar gadget');
        } else {
          Function f = () {
            // _scanDevices();
            blocController.setBluetoothState(true);
          };
          return RoundedButton(f, Colors.blueAccent, icon: Icons.bluetooth_disabled, text: 'Conectar gadget');
        }
      },
    );
  }

  Widget _accountButton(context) {
    final _color = Color.fromRGBO(194, 126, 158, 1.0);
    final blocController = BlocProvider.of(context);

    return StreamBuilder(
      stream: blocController.sesionStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){        
        if (!snapshot.hasData || snapshot.data == 'inactive') {
          return RoundedButton(
            () => utils.signIn(context),
            _color, 
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
                utils.showNiceDialog(context, 'Sesión activa', 'Hola $name, en este momento tienes una sesión activa', callback, 'Cerrar Sesión');
              },
              _color,
              text: '$name',
              backgroundImage: NetworkImage(imageUrl,),
            );
          } else {
            return RoundedButton(
              () => utils.signIn(context),
              _color,
              icon: Icons.account_box, 
              text: 'Mi Cuenta',
            );
          }
        } else {
          return RoundedButton((){},_color, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
      },
    );
  }

  Widget _historyButton(BuildContext context) {
    final _color = Color.fromRGBO(255, 156, 99, 1.0);
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
          return RoundedButton((){}, _color, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
        return RoundedButton(f, _color, icon: Icons.book, text: 'Historial');
      },
    );
  }

  Widget _statsButton(BuildContext context) {
    final _color = Color.fromRGBO(124, 188, 153, 1.0);
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
          return RoundedButton((){}, _color, icon: Icons.radio_button_checked, text: 'Cargando...');
        }
        return RoundedButton(f, _color, icon: Icons.pie_chart_outlined, text: 'Estadísticas');
      },
    );
  }

  Widget _infoButton(context) {
    final _color = Color.fromRGBO(255, 100, 87, 1.0);
    return RoundedButton(
      () => utils.showNiceDialog(context, 'Lie to App', 'www.gerardoarceo.com' , () => {}, 'TQM'), 
      _color, 
      icon: Icons.perm_device_information, 
      text: 'Información'
    );
  }

  Widget _settingsButton(context) {
    final _color = Color.fromRGBO(97, 120, 140, 1.0);
    return RoundedButton(
      (){
        prefs.darkTheme = !prefs.darkTheme;
        Navigator.pushNamed(context, 'main');
      },
      _color,
      icon: Icons.settings_applications, 
      text: 'Configuración'
    );
  }

}
