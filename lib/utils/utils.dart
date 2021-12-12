import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

final backgroundColors = [
  [ //0
    const Color.fromRGBO(236, 98, 188, 1.0),
    const Color.fromRGBO(241, 142, 172, 1.0),
  ],
  [ //1
    const Color.fromRGBO(85, 190, 150, 1.0),
    const Color.fromRGBO(158, 226, 200, 1.0),
  ],
  [//2
    const Color.fromRGBO(52, 72, 236, 1.0),
    const Color.fromRGBO(117, 131, 247, 1.0),
  ],
  [//3
    const Color.fromRGBO(232, 139, 147, 1.0),
    const Color.fromRGBO(237, 88, 102, 1.0),
  ],
];

Widget _gradient() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
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

Widget gradientText(String text, double fontSize) {
  const LinearGradient gradient = LinearGradient(
    colors: [Color.fromRGBO(151, 222, 208, 1), Color.fromRGBO(171, 165, 224, 1), Color.fromRGBO(210, 130, 235, 1)]
  );

  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return gradient.createShader(Offset.zero & bounds.size);
    },
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
      ),
    ),
  );
}

Widget background(int backgroundIndex, {double opacity = 1.0}) {
  final colors = backgroundColors[backgroundIndex];
  colors[0] = colors[0].withOpacity(opacity);
  colors[1] = colors[1].withOpacity(opacity);

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
            colors: colors,
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

  const titleStyle = TextStyle(fontSize: 30.0, color: Colors.white);
  const textStyle = TextStyle(fontSize: 20.0, color: Colors.white);
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
              children: <Widget>[
                const Icon(Icons.error_outline, color: Colors.white, size: 50.0),
                const SizedBox(width: 10,),
                Text(title, style: titleStyle,),
              ],
            ),
            content: Text(text, style: textStyle,),
            actions: <Widget>[
              buttonText == '' ? Container() : TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  callback();
                  Navigator.of(context).pop();
                },
                child: Text(buttonText, style: buttonStyle,),
              ),
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

showInfoDialog(BuildContext context) {

  const titleStyle = TextStyle(fontSize: 30.0, color: Colors.white);
  const textStyle1 = TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white);
  const textStyle2 = TextStyle(fontSize: 17.0, color: Colors.white);
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
              children: const <Widget>[
                Text('Lie to App', style: titleStyle,),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                  children: const <Widget>[
                    Image(
                      image: AssetImage('assets/img/logo_escom.png'),
                      fit: BoxFit.fitWidth,
                    ),
                    SizedBox(width: 30),
                    Image(
                      image: AssetImage('assets/img/logo_upiita.png'),
                      fit: BoxFit.fitWidth,
                    )
                  ]
                ),
                const SizedBox(height: 30),
                const Text('Realizada por:', style: textStyle1,),
                const Text('Lilián Arceo Martínez', style: textStyle2,),
                const Text('Gerardo Arceo Martínez', style: textStyle2,),
              ]),
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

Widget backButton(BuildContext context, {callback}) {
  return InkWell(
    onTap: callback == null ? () => Navigator.pop(context) : () => callback(),
    child: SafeArea(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon( Icons.arrow_back_ios, size: 35, color: Colors.white,),
      ),
    ),
  );
}