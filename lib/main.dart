import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:lie_to_app_2/pages/diagnosis/diagnosis_page.dart';
import 'package:lie_to_app_2/pages/diagnosis/preview_page.dart';
import 'package:lie_to_app_2/pages/diagnosis/results_page.dart';
import 'package:lie_to_app_2/pages/home/info_page.dart';
import 'package:lie_to_app_2/pages/home/tutorial_page.dart';
import 'package:lie_to_app_2/pages/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lie_to_app_2/pages/settings/settings_menu.dart';
import 'package:lie_to_app_2/providers/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:lie_to_app_2/utils/bluetooth.dart' as bluetooth;

import 'bloc/app/app_bloc.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({ Key? key }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppBloc>(create: ( _ ) => AppBloc()),
        BlocProvider<DiagnosisBloc>(create: ( _ ) => DiagnosisBloc())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    bluetooth.connectGadget(context);
    bluetooth.listenChanges(context);

    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(), 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lie to App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ), 
        home: const MainPage(),
        routes: {
            'main': (BuildContext context) => const MainPage(),
            'info': (BuildContext context) => const InfoPage(),
            'tutorial': (BuildContext context) => const TutorialPage(),
            'diagnosis': (BuildContext context) => const DiagnosisPage(),
            'preview': (BuildContext context) => const PreviewPage(),
            'results': (BuildContext context) => const ResultsPage(),
            'settings': (BuildContext context) => const SettingsMenu(),
        },
      )
    );
  }
}
