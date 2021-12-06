import 'package:flutter/material.dart';
// import 'package:lie_to_app/pages/main_page.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lie_to_app_2/pages/main_page.dart';

final titleStyle = TextStyle(fontSize: 55.0, color: Colors.white );
final subtitleStyle = TextStyle(fontSize: 25.0, color: Colors.white, fontStyle: FontStyle.italic);
final textStyle = TextStyle(fontSize: 15.0, color: Colors.white );
final littleStyle = TextStyle(fontSize: 10.0, color: Colors.white );

Container page1() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          Color.fromRGBO(52, 54, 101, 1.0),
          Color.fromRGBO(35, 37, 57, 1.0),
        ]
      )
    ),
    child: Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30.0,),
              Text('El primer detector de', style: subtitleStyle, textAlign: TextAlign.center,),
              Text('mentiras portátil y fiable', style: subtitleStyle, textAlign: TextAlign.center,),
              Expanded(child: Container()),
              Text(
                'Lie to App',
                style: TextStyle(fontSize: 60),
                textAlign: TextAlign.center,
              ),
              SizedBox( height: 10.0 ),
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 120.0,
                child: Image(image: AssetImage('assets/img/ai.png'),),
              ),
              SizedBox(height: 15.0,),
              Text(
                'El poder de la verdad en tu bolsillo',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              Container(
                margin: EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Dance(
                      infinite: true,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.chevron_left, size: 70.0, color: Colors.white,),
                          Text('Saltar', style: textStyle),
                          Text('Información', style: textStyle),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Pulse(
                      delay: Duration(seconds: 4),
                      infinite: true,
                      child: Text('Desliza para avanzar', style: littleStyle)
                    ),
                    Expanded(child: Container()),
                    Dance(
                      infinite: true,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.chevron_right, size: 70.0, color: Colors.white,),
                          Text('Más', style: textStyle),
                          Text('Información', style: textStyle),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Container _page2() {
  return Container(
    color: Colors.pinkAccent,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Text('¿Qué lo hace diferente?', style: titleStyle, textAlign: TextAlign.center,),
          SizedBox( height: 10.0 ),
          Text('Analiza de forma profunda cosas que un polígrafo tradicional ni siquiera toma en cuenta, cómo los micro movimientos oculares y la frecuencia de la señal de voz', style: subtitleStyle, textAlign: TextAlign.justify,),
          Expanded(child: Container()),
        ],
      ),
    ),
  );
}

Container _page3() {
  return Container(
    color: Colors.deepPurpleAccent,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Text('¿Cómo funciona?', style: titleStyle, textAlign: TextAlign.center,),
          SizedBox( height: 10.0 ),
          Text('Con Inteligencia Artificial y Redes Neuronales entrenadas en el reconocimiento de múltiples patrones de comportamiento y fisiológicos que revelan cuándo una persona miente', style: subtitleStyle, textAlign: TextAlign.justify,),
          Expanded(child: Container()),      
        ],
      ),
    ),
  );
}

Container _page4() {
  return Container(
    color: Colors.greenAccent,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Text('¿Para qué sirve?', style: titleStyle, textAlign: TextAlign.center,),
          SizedBox( height: 10.0 ),
          Text('Desde para divertirse con los amigos hasta poder sustituir una prueba química de drogas', style: subtitleStyle, textAlign: TextAlign.justify,),
          Expanded(child: Container()),      
        ],
      ),
    ),
  );
}

final liquidPages = [
  page1(),
  _page2(),
  _page3(),
  _page4(),
  Container(
    child: MainPage(),
  )
];