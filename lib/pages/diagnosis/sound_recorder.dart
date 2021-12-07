import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:lie_to_app_2/constants/app_colors.dart';
import 'package:lie_to_app_2/constants/recorder_constants.dart';
import 'package:lie_to_app_2/widgets/audio_visualizer.dart';

typedef _Fn = void Function();

const theSource = AudioSource.microphone;
String _recorderTxt = '00:00:00';

/// Example app.
class SimpleRecorder extends StatefulWidget {
  const SimpleRecorder({Key? key}) : super(key: key);

  @override
  _SimpleRecorderState createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  bool botonActivado = false;

  final Codec _codec = Codec.aacMP4;
  final String _mPath = 'tau_file.mp4';
  
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;

  @override
  void initState() {
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _mRecorder!.closeAudioSession();
    _mRecorder = null;
    
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    await _mRecorder!.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    ).then((value) {

      _mRecorder!.onProgress!.listen((e) {
        debugPrint('🔫' + e.decibels.toString());
        DateTime date = DateTime.fromMillisecondsSinceEpoch(e.duration.inMilliseconds, isUtc: true);

        setState(() {
          _recorderTxt = date.toString();
        });
      });

    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        var url = value;
        final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
        diagnosisBloc.add( SetAudioPath(url.toString()) );
      });
    });
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }
  
  @override
  Widget build(BuildContext context) {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    diagnosisBloc.state.diagnosisOnProgress.stream.listen((connected) {
      if (getRecorderFn() == null) return;

      if (connected && botonActivado == false) {
        botonActivado = true;
        record();
      } else if (!connected && botonActivado == true) {
        botonActivado = false;
        stopRecorder();
      }
      
    });

    return Container();
    // return Row(
    //   children: [
    //     Spacer(),
    //     StreamBuilder<dynamic>(
    //         initialData: RecorderConstants.decibleLimit,
    //         stream: _mRecorder?.onProgress,
    //         builder: (context, snapshot) {
    //           if (snapshot.hasData) {
    //             print('🧨' + snapshot.data.toString());
    //             return AudioVisualizer(amplitude: double.parse(snapshot.data.toString()));
    //           }
    //           if (snapshot.hasError) {
    //             return Text(
    //               'Visualizer failed to load',
    //               style: TextStyle(color: AppColors.accentColor),
    //             );
    //           } else {
    //             return SizedBox();
    //           }
    //         }),
    //     Spacer(),
    //   ],
    // );
  }
}