import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app_2/utils/utils.dart';

class QuestionsPage extends StatelessWidget {
  final dynamic mode;
  const QuestionsPage({Key? key, this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          background6(),
          ListView(
            children: <Widget>[
              _title(),
              _lista(),
            ],
          ),
          backButton(context),
        ],
      ),
    );
  }

  Widget _lista(){
    List questions = [];
    switch(mode){
      case 1: //Verdad o reto
        questions = [
          {"title":"¿Alguna vez has cortado tu propio cabello?", "difficulty": 1},
          {"title":"¿Alguna vez has cantado mientras te bañas?", "difficulty": 1},
          {"title":"¿Alguna vez has fingido tener novio o novia?", "difficulty": 2},
          {"title":"¿Alguna vez has pasado más de cinco días sin ducharte?", "difficulty": 2},
          {"title":"¿Alguna vez has dudado de tu orientación sexual?", "difficulty": 3},
          {"title":"¿Alguna vez has tapado el baño en la casa de alguien más?", "difficulty": 3},
        ];
        break;
      case 2: //Crimenes
        questions = [
          {"title":"¿Alguna vez has hecho trampa en un examen", "difficulty": 1},
          {"title":"¿Alguna vez has mentido en tu CV?", "difficulty": 1},
          {"title":"¿Alguna vez has disparado un arma de fuego?", "difficulty": 1},
          {"title":"¿Alguna vez has consumido drogas?", "difficulty": 2},
          {"title":"¿Alguna vez has robado en una tienda?", "difficulty": 2},
          {"title":"¿Alguna vez te han arrestado?", "difficulty": 3},
        ];
        break;
      case 3: //Familia
        questions = [
          {"title":"¿Alguna vez has fingido que un chiste te hace gracia?", "difficulty": 1},
          {"title":"¿Alguna vez has tenido una experiencia sobrenatural?", "difficulty": 1},
          {"title":"¿Alguna vez has aprendido a tocar un instrumento musical?", "difficulty": 1},
          {"title":"¿Alguna vez has pasado todo el día viendo videos divertidos en YouTube?", "difficulty": 2},
          {"title":"¿Alguna vez has puesto cara de pato al tomar una selfie?", "difficulty": 2},
          {"title":"¿Alguna vez has fingido encontrarte mal para no ir a una reunión familiar?", "difficulty": 3},
        ];
        break;
      case 4: //Pareja
        questions = [
          {"title":"¿Alguna vez te has enamorado?", "difficulty": 1},
          {"title":"¿Alguna vez has salido con alguien de tu trabajo?", "difficulty": 1},
          {"title":"¿Alguna vez has acosado al novio/novia de un ex en las redes sociales?", "difficulty": 2},
          {"title":"¿Alguna vez has enviado fotos sugerentes a alguien?", "difficulty": 3},
          {"title":"¿Alguna vez has sido infiel?", "difficulty": 3},
        ];
        break;
      case 5: //General
        questions = [
          {"title":"¿Eres un estudiante de ingeniería biónica?", "difficulty": 1},
          {"title":"¿Alguna vez has publicado algo en Facebook?", "difficulty": 1},
          {"title":"¿Has vivido en México toda tu vida?", "difficulty": 1},
          {"title":"¿Alguna vez has tomado una clase en línea?", "difficulty": 1},
          {"title":"¿Alguna vez has viajado en avión?", "difficulty": 1},
          {"title":"¿Eres egresado del MIT?", "difficulty": 1},
          {"title":"¿Alguna vez te has roto un hueso?", "difficulty": 1},
        ];
        break;
      case 6: //Filosofía
        questions = [
          {"title":"¿Crees en Dios?", "difficulty": 1},
          {"title":"¿Alguna vez has sentido que una parte de tu cuerpo no te pertenece?", "difficulty": 1},
          {"title":"¿Crees que vivimos en un universo determinista?", "difficulty": 1},
          {"title":"¿Alguna vez has sentido que vivimos en una simulación?", "difficulty": 2},
          {"title":"¿Aluna vez has sentido que tu vida no tiene sentido?", "difficulty": 3},
        ];
        break;
    }
    List<Widget> list = [];
    questions.forEach((question) {
      Icon icon = Icon(Icons.star, color: Color.fromRGBO(85, 190, 150, 1.0));
      if(question["difficulty"] == 2) {
        icon = Icon(Icons.star, color: Color.fromRGBO(247, 140, 50, 1.0));
      } else if(question["difficulty"] == 3) {
        icon = Icon(Icons.star, color: Color.fromRGBO(242, 61, 40, 1.0));
      }

      var card = Card(
        child: ListTile(
          title: Text(question['title']),
          leading: icon
        )
      );
      list.add(card);
    });
    return Column(
      children: list,
    );
  }

  Widget _title() {
    String title = "";
    switch(mode){
      case 1: //Verdad o reto
        title = "Verdad o reto";
        break;
      case 2: //Crimenes
        title = "Preguntas de crímenes";
        break;
      case 3: //Familia
        title = "Preguntas en familia";
        break;
      case 4: //Pareja
        title = "Preguntas en pareja";
        break;
      case 5: //General
        title = "Preguntas generales";
        break;
      case 6: //Filosofía
        title = "Preguntas filosóficas";
        break;
    }

    String asd = "";
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 20.0,),
          Text(title, style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          const SizedBox(height: 20.0,),
          const Text('El tiempo descubre la verdad', style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }
}
