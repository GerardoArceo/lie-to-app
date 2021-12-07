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

class ResetEyeTrackingResults extends DiagnosisEvent {
  ResetEyeTrackingResults();
}

class ResetBpmResults extends DiagnosisEvent {
  ResetBpmResults();
}