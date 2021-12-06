part of 'app_bloc.dart';

@immutable
abstract class AppState {
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final bluetoothConected = BehaviorSubject<bool>.seeded(false);
  
  bool? get isBluetoothConected => bluetoothConected.value;
}

class AppInitial extends AppState {}
