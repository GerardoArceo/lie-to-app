part of 'diagnosis_bloc.dart';

@immutable
abstract class DiagnosisState {
    final diagnosisOnProgress = BehaviorSubject<bool>.seeded(false);
    final gadget = BehaviorSubject<BluetoothDevice>();
    final bpm = BehaviorSubject<int>();
    final eyeTrackingResults = BehaviorSubject<List<int>>.seeded([]);
    final bpmResults = BehaviorSubject<List<int>>.seeded([]);
    final audioPath = BehaviorSubject<String>();

    bool? get diagnosisOnProgressValue => diagnosisOnProgress.value;
    String? get audioPathValue => audioPath.value;
    int? get bpmValue => bpm.value;
    BluetoothDevice? get gadgetValue => gadget.value;
    List<int>? get eyeTrackingResultsValue => eyeTrackingResults.value;
    List<int>? get bpmResultsValue => bpmResults.value;
}

class DiagnosisInitial extends DiagnosisState {}
