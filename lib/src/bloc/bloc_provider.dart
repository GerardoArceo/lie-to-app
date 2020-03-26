import 'package:flutter/material.dart';
import 'package:lie_to_app/src/bloc/bloc_controller.dart';

class BlocProvider extends InheritedWidget {

  final _blocController = new BlocController();

  static BlocProvider _instance;

  factory BlocProvider({Key key, Widget child}) {
    if (_instance == null) {
      _instance = new BlocProvider._internal(key: key, child: child);
    }
    return _instance;
  }

  BlocProvider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BlocController of ( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<BlocProvider>()._blocController;
  }
  
}