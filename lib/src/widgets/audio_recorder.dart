import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:lie_to_app/src/bloc/bloc_provider.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;

enum t_MEDIA {
  FILE,
}

class AudioRecorder extends StatefulWidget {
  @override
  _AudioState createState() => new _AudioState();
}

class _AudioState extends State<AudioRecorder> {
  bool _isRecording = false;
  List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  static FlutterSound flutterSoundModule;

  String _recorderTxt = '00:00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  bool _encoderSupported = true; // Optimist

  void _initializeExample(FlutterSound module) async {
    flutterSoundModule = module;
    flutterSoundModule.initializeMediaPlayer();
    flutterSoundModule.setSubscriptionDuration(0.01);
    flutterSoundModule.setDbPeakLevelUpdate(0.8);
    flutterSoundModule.setDbLevelEnabled(true);
    initializeDateFormatting();
  }

  @override
  void initState() {
    super.initState();
    _initializeExample(FlutterSound());
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
    if (_dbPeakSubscription != null) {
      _dbPeakSubscription.cancel();
      _dbPeakSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelRecorderSubscriptions();
  }

  void startRecorder() async {
    try {
      Directory tempDir = await getTemporaryDirectory();

      String path = await flutterSoundModule.startRecorder(
        uri: '${tempDir.path}/sound.aac',
        codec: _codec,
      );
      print('startRecorder: $path');

      _recorderSubscription = flutterSoundModule.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(), isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);

        this.setState(() {
          this._recorderTxt = txt.substring(0, 8);
        });
      });
      _dbPeakSubscription = flutterSoundModule.onRecorderDbPeakChanged.listen((value) {
        print("got update -> $value");
        setState(() {
          this._dbLevel = value;
        });
      });

      this.setState(() {
        this._isRecording = true;
        this._path[_codec.index] = path;
      });
    } catch (err) {
      print('startRecorder error: $err');
      setState(() {
        stopRecorder();
        this._isRecording = false;
        if (_recorderSubscription != null) {
          _recorderSubscription.cancel();
          _recorderSubscription = null;
        }
        if (_dbPeakSubscription != null) {
          _dbPeakSubscription.cancel();
          _dbPeakSubscription = null;
        }
      });
    }
  }

  void stopRecorder() async {
    
    try {
      String result = await flutterSoundModule.stopRecorder();
      print('stopRecorder: $result');
      cancelRecorderSubscriptions();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    this.setState(() {
      this._isRecording = false;
    });
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  @override
  Widget build(BuildContext context) {

    final blocController = BlocProvider.of(context);

    Widget recorderSection;
    
    if (flutterSoundModule.audioState == t_AUDIO_STATE.IS_RECORDING) 
      recorderSection = Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
          child: Text(
            this._recorderTxt,
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.white,
            ),
          ),
        ),
        _isRecording ? LinearProgressIndicator(value: 100.0 / 160.0 * (this._dbLevel ?? 1) / 100, valueColor: AlwaysStoppedAnimation<Color>(Colors.green), backgroundColor: Colors.red) : Container(),
      ]);
    else recorderSection = Container();

    return StreamBuilder(
      stream: blocController.recordStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
        if (snapshot == null) return Container();
        if (snapshot.data == 'start' && flutterSoundModule.audioState != t_AUDIO_STATE.IS_RECORDING) {
          startRecorder();
          blocController.setRecordState('recording');
        } else if (snapshot.data == 'stop' && flutterSoundModule.audioState == t_AUDIO_STATE.IS_RECORDING) {
          print('DETENER');
          stopRecorder();
        }
        return recorderSection;
      },
    );
  }
}
