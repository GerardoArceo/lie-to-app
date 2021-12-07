import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lie_to_app_2/pages/main_page.dart';

const titleStyle = TextStyle(fontSize: 55.0, color: Colors.white );
const subtitleStyle = TextStyle(fontSize: 25.0, color: Colors.white, fontStyle: FontStyle.italic);
const textStyle = TextStyle(fontSize: 15.0, color: Colors.white );
const littleStyle = TextStyle(fontSize: 10.0, color: Colors.white );

Container page1() {
  return Container(
    width: double.infinity,
    height: double.infinity,
    decoration: const BoxDecoration(
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
              const SizedBox(height: 30.0,),
              const Text('El primer detector de', style: subtitleStyle, textAlign: TextAlign.center,),
              const Text('mentiras portátil y fiable', style: subtitleStyle, textAlign: TextAlign.center,),
              Expanded(child: Container()),
              const Text(
                'Lie to App',
                style: TextStyle(fontSize: 60),
                textAlign: TextAlign.center,
              ),
              const SizedBox( height: 10.0 ),
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 120.0,
                child: Image(image: AssetImage('assets/img/ai.png'),),
              ),
              const SizedBox(height: 15.0,),
              const Text(
                'El poder de la verdad en tu bolsillo',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Expanded(child: Container()),
              Container(
                margin: const EdgeInsets.all(8),
                child: Row(
                  children: <Widget>[
                    Dance(
                      infinite: true,
                      child: Column(
                        children: const <Widget>[
                          Icon(Icons.chevron_left, size: 70.0, color: Colors.white,),
                          Text('Saltar', style: textStyle),
                          Text('Información', style: textStyle),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Pulse(
                      delay: const Duration(seconds: 4),
                      infinite: true,
                      child: const Text('Desliza para avanzar', style: littleStyle)
                    ),
                    Expanded(child: Container()),
                    Dance(
                      infinite: true,
                      child: Column(
                        children: const <Widget>[
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          const Text('¿Qué lo hace diferente?', style: titleStyle, textAlign: TextAlign.center,),
          const SizedBox( height: 10.0 ),
          const Text('Analiza de forma profunda cosas que un polígrafo tradicional ni siquiera toma en cuenta, cómo los micro movimientos oculares y la frecuencia de la señal de voz', style: subtitleStyle, textAlign: TextAlign.justify,),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          const Text('¿Cómo funciona?', style: titleStyle, textAlign: TextAlign.center,),
          const SizedBox( height: 10.0 ),
          const Text('Con Inteligencia Artificial y Redes Neuronales entrenadas en el reconocimiento de múltiples patrones de comportamiento y fisiológicos que revelan cuándo una persona miente', style: subtitleStyle, textAlign: TextAlign.justify,),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          const Text('¿Para qué sirve?', style: titleStyle, textAlign: TextAlign.center,),
          const SizedBox( height: 10.0 ),
          const Text('Desde para divertirse con los amigos hasta poder sustituir una prueba química de drogas', style: subtitleStyle, textAlign: TextAlign.justify,),
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
  const MainPage(),
];