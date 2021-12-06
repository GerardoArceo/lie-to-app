import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

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
                title: Text("${element['hit_probability']}% de probabilidad"),
                subtitle: Text("Fecha: $date"),
                leading: element['final_result'] == 1 ? Text('Verdad') : Text('Mentira'),
                trailing: element['was_right'] == null ? Icon(Icons.star) : (element['was_right'] == 1 ? Icon(Icons.check_box) : Icon(Icons.error_outline))
              )
            );
            list.add(card);
          });
          print('🐯 ${snapshot.data}');
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
          Text('Estadísticas', style: TextStyle(color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.bold),),
          SizedBox(height: 20.0,),
          Text('Una mentira pone en duda todas las verdades', style: TextStyle(color: Colors.white, fontSize: 18.0))
        ],
      ),
    );
  }
}
