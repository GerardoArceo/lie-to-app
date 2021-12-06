import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:lie_to_app_2/pages/main_page.dart';

class TutorialPage extends StatelessWidget {
  const TutorialPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          _page1(),
          _page2(),
          _page3(),
          const MainPage()
        ],
      )
    );
  }

  Widget _page1() {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 60.0);
    return Stack(
      children: <Widget>[
        _backgroundColor(),
        _backgroundImage(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              const Text('TUTORIAL', style: titleStyle),
              Expanded(child: Container()),
              _arrow(),
              const SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _page2() {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0);

    return Stack(
      children: <Widget>[
        _backgroundColor(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              const Text('¿Cómo se usa el gadget?', style: titleStyle),
              const Image(
                image: AssetImage('assets/img/tutorial.png'),
                fit: BoxFit.cover,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Indicator(
                    color: Color.fromRGBO(82, 180, 94, 1),
                    text: 'Electrodo ojo derecho',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Indicator(
                    color: Color.fromRGBO(234, 215, 119, 1),
                    text: 'Referencia',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Indicator(
                    color: Color.fromRGBO(234, 51, 36, 1),
                    text: 'Electrodo ojo izquierdo',
                    isSquare: true,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Indicator(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    text: 'Sensor de frecuencia cardiaca',
                    isSquare: true,
                  ),
                ],
              ),
              Expanded(child: Container()),
              _arrow(),
              const SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _page3() {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30.0);
    const textStyle = TextStyle(color: Colors.white, fontSize: 17.0);
    
    final tips = Column(
      children: const [
        Card(
          color: Colors.transparent,
          child: ListTile(
            title: Text('Haz preguntas con respuestas simples, de preferencia que se puedan contestar con una sola palabra.', style: textStyle),
            leading: Text('1', style: titleStyle)
          )
        ),
        Card(
          color: Colors.transparent,
          child: ListTile(
            title: Text('Realiza los diagnósticos en una habitación tranquila dónde puedas sentarte.', style: textStyle),
            leading: Text('2', style: titleStyle)
          )
        ),
        Card(
          color: Colors.transparent,
          child: ListTile(
            title: Text('Durante el diagnóstico no realices movimientos bruscos y trata de mantener la mirada fija.', style: textStyle),
            leading: Text('3', style: titleStyle)
          )
        ),
        Card(
          color: Colors.transparent,
          child: ListTile(
            title: Text('Cualquier uso que se le pueda dar a esta aplicación es responsabilidad de quien la utiliza.', style: textStyle),
            leading: Text('4', style: titleStyle)
          )
        ),
      ],
    );

    return Stack(
      children: <Widget>[
        _backgroundColor(),
        SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(child: Container()),
              const Text('Recomendaciones', style: titleStyle),
              const Image(
                image: AssetImage('assets/img/cabeza.png'),
                fit: BoxFit.cover,
              ),
              tips,
              Expanded(child: Container()),
              _arrow(),
              const SizedBox(height: 20.0,),
            ],
          ),
        )
      ],
    );
  }

  Widget _backgroundColor() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color.fromRGBO(108, 192, 218, 1)
    );
  }

  Widget _backgroundImage() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage('assets/img/scroll.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _arrow() {
    const textStyle = TextStyle(fontSize: 15.0, color: Colors.white );
    return Column(
      children: <Widget>[
        Pulse(
          infinite: true,
          child: const Icon(Icons.keyboard_arrow_down, size: 70.0, color: Colors.white,)
        ),
      ]
    );
  }

}



class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xeeeeeeee),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 20,
        ),
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}