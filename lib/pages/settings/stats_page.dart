import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lie_to_app_2/pages/settings/line_chart.dart';
import 'package:lie_to_app_2/pages/settings/pie_chart.dart';
import 'package:lie_to_app_2/providers/cloud_api.dart';
import 'package:lie_to_app_2/utils/utils.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: <Widget>[
          background(2, opacity: 0.6),
          Column(
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
          return Column(children: [
            const Text('Probabilidad de acierto en los diagnósticos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
            LineChart1(data: snapshot.data),
            const SizedBox(height: 20.0,),
            const Text('Porcentaje de diagnósticos correctos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0)),
            PieChart1(data: snapshot.data),
          ]);
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
        ],
      ),
    );
  }
}
