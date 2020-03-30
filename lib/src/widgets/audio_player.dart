import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flauto.dart';

enum t_MEDIA {
  FILE,
}

class AudioPlayer extends StatefulWidget {
  @override
  _AudioState createState() => new _AudioState();
}

class _AudioState extends State<AudioPlayer> {
  List<String> _path = [null, null, null, null, null, null, null];
  StreamSubscription _playerSubscription;
  StreamSubscription _playbackStateSubscription;
  static FlutterSound flutterSoundModule;

  String _playerTxt = '00:00:00';

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  t_CODEC _codec = t_CODEC.CODEC_AAC;

  bool _encoderSupported = true; // Optimist
  bool _decoderSupported = true; // Optimist

  // Whether the user wants to use the audio player features
  bool _isAudioPlayer = false;

  void _initializeExample(FlutterSound module) async {
    flutterSoundModule = module;
    flutterSoundModule.initializeMediaPlayer();
    flutterSoundModule.setSubscriptionDuration(0.01);
    flutterSoundModule.setDbPeakLevelUpdate(0.8);
    flutterSoundModule.setDbLevelEnabled(true);
    initializeDateFormatting();
    setCodec(_codec);

    Directory tempDir = await getTemporaryDirectory();
    this._path[_codec.index] = '${tempDir.path}/sound.aac';
  }

  @override
  void initState() {
    super.initState();
    _initializeExample(FlutterSound());
  }
  
  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
      _playerSubscription = null;
    }

    if (_playbackStateSubscription != null) {
      _playbackStateSubscription.cancel();
      _playbackStateSubscription = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelPlayerSubscriptions();
    releasePlayer();
  }

  Future<void> releasePlayer() async {
    try {
      await flutterSoundModule.releaseMediaPlayer();
      print('media player released successfully');
    } catch (e) {
      print('media player released unsuccessful');
      print(e);
    }
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  void _addListeners() {
    cancelPlayerSubscriptions();
    _playerSubscription = flutterSoundModule.onPlayerStateChanged.listen((e) {
      if (e != null) {
        sliderCurrentPosition = e.currentPosition;
        maxDuration = e.duration;

        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt(), isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        this.setState(() {
          //this._isPlaying = true;
          this._playerTxt = txt.substring(0, 8);
        });
      }
    });
  }

  Future<void> startPlayer() async {

    try {
      String path;
      Uint8List dataBuffer;
      String audioFilePath;
      if (await fileExists(_path[_codec.index])) audioFilePath = this._path[_codec.index];
      

      // Check whether the user wants to use the audio player features
    if (_isAudioPlayer) {
        String albumArtUrl;
        String albumArtAsset;
        
        if (Platform.isIOS) {
          albumArtAsset = 'AppIcon';
        } else if (Platform.isAndroid) {
          albumArtAsset = 'AppIcon.png';
        }

    final track = Track(
          trackPath: audioFilePath,
          dataBuffer: dataBuffer,
          codec: _codec,
          trackTitle: "This is a record",
          trackAuthor: "from flutter_sound",
          albumArtUrl: albumArtUrl,
          albumArtAsset: albumArtAsset,
        );

    Flauto flauto = flutterSoundModule;
        path = await flauto.startPlayerFromTrack(
          track,
          /*canSkipForward:true, canSkipBackward:true,*/
          whenFinished: () {
            print('I hope you enjoyed listening to this song');
          },
          onSkipBackward: () {
            print('Skip backward');
            stopPlayer();
            startPlayer();
          },
          onSkipForward: () {
            print('Skip forward');
            stopPlayer();
            startPlayer();
          },
        );
      } else {
        
        if (audioFilePath != null) {
          path = await flutterSoundModule.startPlayer(audioFilePath, codec: _codec, whenFinished: () {
            print('Play finished');
            setState(() {});
          });
        } else if (dataBuffer != null) {
          path = await flutterSoundModule.startPlayerFromBuffer(dataBuffer, codec: _codec, whenFinished: () {
            print('Play finished');
            setState(() {});
          });
        }

        if (path == null) {
          print('Error starting player');
          return;
        }
      }
      _addListeners();

      print('startPlayer: $path');
      // await flutterSoundModule.setVolume(1.0);
    } catch (err) {
      print('error: $err');
    }
    setState(() {});
  }

  Future<void> stopPlayer() async {
    try {
      String result = await flutterSoundModule.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } catch (err) {
      print('error: $err');
    }
    this.setState(() {
      //this._isPlaying = false;
    });
  }

  pauseResumePlayer() {
    if (flutterSoundModule.audioState == t_AUDIO_STATE.IS_PLAYING) {
      flutterSoundModule.pausePlayer();
    } else {
      flutterSoundModule.resumePlayer();
    }
  }

  void seekToPlayer(int milliSecs) async {
    String result = await flutterSoundModule.seekToPlayer(milliSecs);
    print('seekToPlayer: $result');
  }

  onPauseResumePlayerPressed() {
    switch (flutterSoundModule.audioState) {
      case t_AUDIO_STATE.IS_PAUSED:
        return pauseResumePlayer;
        break;
      case t_AUDIO_STATE.IS_PLAYING:
        return pauseResumePlayer;
        break;
      case t_AUDIO_STATE.IS_STOPPED:
        return null;
        break;
      case t_AUDIO_STATE.IS_RECORDING:
        return null;
        break;
    }
  }

  onStopPlayerPressed() {
    return flutterSoundModule.audioState == t_AUDIO_STATE.IS_PLAYING || flutterSoundModule.audioState == t_AUDIO_STATE.IS_PAUSED ? stopPlayer : null;
  }

  onStartPlayerPressed() {
    if (_path[_codec.index] == null) return null;
    return flutterSoundModule.audioState == t_AUDIO_STATE.IS_STOPPED ? startPlayer : null;
  }

  setCodec(t_CODEC codec) async {
    _encoderSupported = await flutterSoundModule.isEncoderSupported(codec);
    _decoderSupported = await flutterSoundModule.isDecoderSupported(codec);

    setState(() {
      _codec = codec;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget playerSection = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
          child: Text(
            this._playerTxt,
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.white,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onStartPlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    image: AssetImage(onStartPlayerPressed() != null ? 'res/icons/ic_play.png' : 'res/icons/ic_play_disabled.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onPauseResumePlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    width: 36.0,
                    height: 36.0,
                    image: AssetImage(onPauseResumePlayerPressed() != null ? 'res/icons/ic_pause.png' : 'res/icons/ic_pause_disabled.png'),
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 50.0,
              child: ClipOval(
                child: FlatButton(
                  onPressed: onStopPlayerPressed(),
                  disabledColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                    width: 28.0,
                    height: 28.0,
                    image: AssetImage(onStopPlayerPressed() != null ? 'res/icons/ic_stop.png' : 'res/icons/ic_stop_disabled.png'),
                  ),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
        Container(
            height: 30.0,
            child: Slider(
              inactiveColor: Colors.indigo,
              activeColor: Colors.pink,
                value: sliderCurrentPosition,
                min: 0.0,
                max: maxDuration,
                onChanged: (double value) async {
                  await flutterSoundModule.seekToPlayer(value.toInt());
                },
                divisions: maxDuration == 0.0 ? 1 : maxDuration.toInt())),
      ],
    );

    return playerSection;
  }
}