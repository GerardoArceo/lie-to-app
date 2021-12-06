part of 'diagnosis_bloc.dart';

@immutable
abstract class DiagnosisEvent {}

class SetDiagnosisOnProgress extends DiagnosisEvent {
  final bool diagnosisOnProgress;
  SetDiagnosisOnProgress(this.diagnosisOnProgress);
}

class SetAudioPath extends DiagnosisEvent {
  final String audioPath;
  SetAudioPath(this.audioPath);
}

class SetGadget extends DiagnosisEvent {
  final BluetoothDevice gadget;
  SetGadget(this.gadget);
}

class SetEyeTrackingResults extends DiagnosisEvent {
  final List<int> eyeTrackingResults;
  SetEyeTrackingResults(this.eyeTrackingResults);
}

class SetBpmResults extends DiagnosisEvent {
  final List<int> bpmResults;
  SetBpmResults(this.bpmResults);
}