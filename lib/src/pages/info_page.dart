import 'package:flutter/material.dart';
import 'package:lie_to_app/src/preferences/user_prefs.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lie_to_app/src/widgets/liquid_pages.dart';

class InfoPage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final prefs = new UserPrefs();
    prefs.showInitialInfo = false;

    return Scaffold(
      body: LiquidSwipe(
        pages: liquidPages,
        fullTransitionValue: 300,
        waveType: WaveType.liquidReveal,
        onPageChangeCallback: (page) => pageChangeCallback(context, page),
        currentUpdateTypeCallback: ( updateType ) => updateTypeCallback( updateType ),
      )
    );
  }

  pageChangeCallback(BuildContext context, int page) {
    if (page + 1 == liquidPages.length) {
      Navigator.pushReplacementNamed(context, 'main');
    }
  }

  updateTypeCallback( UpdateType updateType) {}

}