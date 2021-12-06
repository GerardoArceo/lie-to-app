import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:lie_to_app_2/widgets/liquid_pages.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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