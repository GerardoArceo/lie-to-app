import 'dart:ui';

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {

  final color, icon, text, callback, backgroundImage;
  RoundedButton(this.callback, this.color, {this.text, this.icon, this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
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
                  color: Color.fromRGBO(62, 66, 107, 0.7),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SizedBox( height: 5.0 ),
                    CircleAvatar(
                      backgroundColor: color,
                      radius: 35.0,
                      child: icon != null ? Icon(icon, color: Colors.white, size: 30.0) : Container(),
                      backgroundImage: backgroundImage,
                    ),
                    Text( text , style: TextStyle( color: color )),
                    SizedBox( height: 5.0 )
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
