import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:lie_to_app/src/pages/diagnosis/diagnosis_page.dart';
import 'package:lie_to_app/src/pages/diagnosis/preview_page.dart';
import 'package:lie_to_app/src/pages/diagnosis/results_page.dart';
import 'package:lie_to_app/src/pages/home/info_page.dart';
import 'package:lie_to_app/src/pages/home/tutorial_page.dart';
import 'package:lie_to_app/src/pages/main_page.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';
 
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPrefs();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final prefs = new UserPrefs();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lie to App',
        initialRoute: prefs.showInitialInfo ? 'info' : 'main',
        routes: {
          'main': (BuildContext context) => MainPage(),
          'info': (BuildContext context) => InfoPage(),
          'tutorial': (BuildContext context) => TutorialPage(),
          'diagnosis': (BuildContext context) => DiagnosisPage(),
          'preview': (BuildContext context) => PreviewPage(),
          'results': (BuildContext context) => ResultsPage(),
        },
      ),
    );
  }
}