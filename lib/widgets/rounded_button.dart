import 'dart:ui';

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final dynamic callback;
  final Color color;
  final String? text;
  final IconData? icon;
  final ImageProvider<Object>? backgroundImage;

  const RoundedButton(this.callback, this.color, {this.text, this.icon, this.backgroundImage, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: callback,
          borderRadius: BorderRadius.circular(20.0),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(20.0),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                height: 180.0,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(62, 66, 107, 0.7),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const SizedBox( height: 5.0 ),
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 35.0,
                      child: icon != null ? Icon(icon, color: Colors.white, size: 30.0) : Container(),
                      backgroundImage: backgroundImage,
                    ),
                    Text( text ?? '' , style: TextStyle( color: color )),
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
