import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
    return FutureBuilder(
      future: CloudApiProvider().sendGetRequest({}, 'get_user_diagnosis'),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<Widget> list = [];
          snapshot.data.forEach((element) {
            var date = element['created_date'].split('T')[0] + ' a las ' + element['created_date'].split('T')[1].split('.')[0];
            var card = Card(
              child: ListTile(
                title: Text("${element['hit_probability']}% de probabilidad de diagnóstico correcto"),
                subtitle: Text("Fecha: $date"),
                leading: element['final_result'] == 1 ? Text('Verdad', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(85, 190, 150, 1.0))) : Text('Mentira', style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(254, 115, 108, 1.0))),
                trailing: element['was_right'] == null ? Icon(Icons.adjust_sharp): (element['was_right'] == 1 ? Icon(Icons.check_circle, color: Color.fromRGBO(85, 190, 150, 1.0)) : Icon(Icons.error, color: Color.fromRGBO(254, 115, 108, 1.0)))
              )
            );
            list.add(card);
          });
          return Column(
            children: list,
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _title() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SizedBox(height: 20.0,),
          Text('Historial', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 20.0,),
          Text('Una mentira pone en duda todas las verdades', style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }
}
