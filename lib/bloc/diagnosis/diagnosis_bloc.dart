import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_blue/flutter_blue.dart';

part 'diagnosis_event.dart';
part 'diagnosis_state.dart';

class DiagnosisBloc extends Bloc<DiagnosisEvent, DiagnosisState> {
  DiagnosisBloc() : super(DiagnosisInitial()) {
    on<DiagnosisEvent>((event, emit) {

      if (event is SetDiagnosisOnProgress ) {
        state.diagnosisOnProgress.sink.add(event.diagnosisOnProgress);
      } else if (event is SetAudioPath ) {
        state.audioPath.sink.add(event.audioPath);
      } else if (event is SetGadget ) {
        state.gadget.sink.add(event.gadget);
      } else if (event is ResetEyeTrackingResults ) {
        state.eyeTrackingResults.sink.add([]);
      } else if (event is ResetBpmResults ) {
        state.bpmResults.sink.add([]);
      } 

    });
  }
}
