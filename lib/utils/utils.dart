import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';

Widget _gradient() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset(0.0, 0.6),
        end:  FractionalOffset(0.0, 1.0),
        colors: [
          Color.fromRGBO(52, 54, 101, 1.0),
          Color.fromRGBO(35, 37, 57, 1.0),
        ]
      )
    ),
  );
}

Widget background1() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(236, 98, 188, 1.0),
              Color.fromRGBO(241, 142, 172, 1.0),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

Widget background2() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(85, 190, 150, 1.0),
              Color.fromRGBO(158, 226, 200, 1.0),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

Widget background3() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(52, 72, 236, 1.0),
              Color.fromRGBO(117, 131, 247, 1.0),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

Widget background4() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(232, 139, 147, 0.6),
              Color.fromRGBO(237, 88, 102, 0.6),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

Widget background5() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(232, 139, 147, 0.8),
              Color.fromRGBO(237, 88, 102, 0.8),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

Widget background6() {
  final pinkBox = Positioned(
    top: -100.0,
    child: Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        height: 360.0,
        width: 360.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80.0),
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(232, 139, 147, 1.0),
              Color.fromRGBO(237, 88, 102, 1.0),
            ]
          )
        ),
      )
    )
  );

  return Stack(
    children: <Widget>[
      _gradient(),
      pinkBox,
    ],
  );
}

showNiceDialog(BuildContext context, String title, String text, Function callback, String buttonText) {

  final titleStyle = TextStyle(fontSize: 30.0, color: Colors.white);
  final textStyle = TextStyle(fontSize: 20.0, color: Colors.white);
  final buttonStyle = TextStyle(fontSize: 15.0, color: Color.fromRGBO(241,125, 160, 1));

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
            backgroundColor: Color.fromRGBO(241,125, 170, 0.8),
            title: Row(
              children: <Widget>[
                Icon(Icons.error_outline, color: Colors.white, size: 50.0),
                SizedBox(width: 10,),
                Text(title, style: titleStyle,),
              ],
            ),
            content: Text(text, style: textStyle,),
            actions: <Widget>[
              buttonText == '' ? Container() : FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text(buttonText, style: buttonStyle,),
                onPressed: () {
                  callback();
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                child: Text('OK', style: buttonStyle,),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 200),
    barrierDismissible: true,
    barrierLabel: '',
    context: context,
    pageBuilder: (context, animation1, animation2) {
      return Container();
    }
  );
}

Widget backButton(BuildContext context, {callback}) {
  return InkWell(
    onTap: callback == null ? () => Navigator.pop(context) : () => callback(),
    child: SafeArea(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Icon( Icons.arrow_back_ios, size: 35, color: Colors.white,),
      ),
    ),
  );
}