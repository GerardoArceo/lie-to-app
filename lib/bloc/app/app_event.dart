part of 'app_bloc.dart';

@immutable
abstract class AppEvent {}

class SetLoadingState extends AppEvent {
  final bool loadingState;
  SetLoadingState(this.loadingState);
}

class SetBluetoothState extends AppEvent {
  final bool bluetoothState;
  SetBluetoothState(this.bluetoothState);
}