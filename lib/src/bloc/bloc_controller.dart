import 'package:rxdart/rxdart.dart';

class BlocController {

  final _loadingController = new BehaviorSubject<bool>();
  final _bluetoothController = new BehaviorSubject<bool>();
  final _recordController = new BehaviorSubject<String>();
  final _sesionController = new BehaviorSubject<String>();

  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<bool> get bluetoothStream => _bluetoothController.stream;
  Stream<String> get recordStream => _recordController.stream;
  Stream<String> get sesionStream => _sesionController.stream;

  void setLoadingState(bool state) async {
    _loadingController.sink.add(state);
  }

  void setBluetoothState(bool state) async {
    _bluetoothController.sink.add(state);
  }

  void setRecordState(String state) async {
    _recordController.sink.add(state);
  }

  getRecordState() {
    return _recordController.value;
  }

  void setSessionState(String state) async {
    _sesionController.sink.add(state);
  }

  dispose() {
    _loadingController?.close();
    _bluetoothController?.close();
    _recordController?.close();
    _sesionController?.close();
  }

}
