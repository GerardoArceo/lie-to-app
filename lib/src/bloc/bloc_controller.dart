import 'package:rxdart/subjects.dart';

class BlocController {

  final _loadingController = new BehaviorSubject<bool>();
  final _bluetoothController = new BehaviorSubject<bool>();
  final _sesionController = new BehaviorSubject<String>();

  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<bool> get bluetoothStream => _bluetoothController.stream;
  Stream<String> get sesionStream => _sesionController.stream;

  void setLoadingState(bool state) async {
    _loadingController.sink.add(state);
  }

  void setBluetoothState(bool state) async {
    _bluetoothController.sink.add(state);
  }

  void setSessionState(String state) async {
    _sesionController.sink.add(state);
  }

  dispose() {
    _loadingController?.close();
    _bluetoothController?.close();
    _sesionController?.close();
  }

}
