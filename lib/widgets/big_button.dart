import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {

  final dynamic callback;
  final String image;
  final String text;
  final bool animate;
  const BigButton(this.callback, this.image, this.text, {this.animate = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final Shader linearGradient = const LinearGradient(
      colors: [Color.fromRGBO(151, 222, 208, 1), Color.fromRGBO(171, 165, 224, 1), Color.fromRGBO(210, 130, 235, 1)]
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));

    return Container(
      margin: const EdgeInsets.all(35.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: callback,
          borderRadius: BorderRadius.circular(80.0),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(80.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                height: size.width * 0.8,
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(62, 66, 107, 0.7),
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const SizedBox( height: 5.0 ),
                    
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 80.0,
                      child: Flash(
                        animate: animate,
                        infinite: true,
                        child: Image(image: AssetImage(image),),
                      ),
                    ),
                    Text(
                      text,
                      style: TextStyle(fontSize: 20, foreground: Paint()..shader = linearGradient),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox( height: 5.0 )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
