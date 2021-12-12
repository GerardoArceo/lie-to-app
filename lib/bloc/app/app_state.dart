part of 'app_bloc.dart';

@immutable
abstract class AppState {
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final bluetoothConected = BehaviorSubject<bool>.seeded(false);
  final apiURL = BehaviorSubject<String>.seeded('Lili');
  final diagnosisLite = BehaviorSubject<bool>.seeded(true);
  
  bool? get isBluetoothConected => bluetoothConected.value;
  String? get apiURLValue => apiURL.value;
  bool? get isDiagnosisLite => diagnosisLite.value;
}

class AppInitial extends AppState {}
