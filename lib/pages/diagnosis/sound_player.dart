import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lie_to_app_2/widgets/rounded_button.dart';

Codec _codec = Codec.mp3;
String _mPath = 'tau_file.mp4';

typedef Fn = void Function();

/// Example app.
class SimplePlayback extends StatefulWidget {
  const SimplePlayback({Key? key}) : super(key: key);

  @override
  _SimplePlaybackState createState() => _SimplePlaybackState();
}

class _SimplePlaybackState extends State<SimplePlayback> {
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;

  @override
  void initState() {
    super.initState();
    _mPlayer!.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
  }

  @override
  void dispose() {
    stopPlayer();
    // Be careful : you must `close` the audio session when you have finished with it.
    _mPlayer!.closeAudioSession();
    _mPlayer = null;

    super.dispose();
  }

  // -------  Here is the code to playback a remote file -----------------------

  void play() async {
    await _mPlayer!.startPlayer(
        fromURI: _mPath,
        codec: _codec,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_mPlayer != null) {
      await _mPlayer!.stopPlayer();
    }
  }

  // --------------------- UI -------------------

  Fn? getPlaybackFn() {
    if (!_mPlayerIsInited) {
      return null;
    }
    return _mPlayer!.isStopped
        ? play
        : () {
            stopPlayer().then((value) => setState(() {}));
          };
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {

      return Table(
        children: [
          TableRow(
            children: [
              RoundedButton(getPlaybackFn(), Colors.blueAccent, icon: Icons.play_circle_outline, text: _mPlayer!.isPlaying ? 'Stop' : 'Play'),
            ]
          ),
        ],
      );
    }

    return makeBody();
  }
}