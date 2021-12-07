import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

listenChanges(context) {
  final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
  final appBloc = BlocProvider.of<AppBloc>(context);

  diagnosisBloc.state.gadget.stream.listen((gadget) {
    gadget.state.listen((state) async {
      if (state == BluetoothDeviceState.connected) {
        debugPrint('🐻 LIE TO GADGET CONNECTED: ' + gadget.id.toString());
        appBloc.add( SetBluetoothState(true) );
      } else {
        debugPrint('🐻 LIE TO GADGET DISCONNECTED: ' + gadget.id.toString());
        appBloc.add( SetBluetoothState(false) );
      }
    });
  });
}

disconnectGadget(context) async {
  final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
  final gadget = diagnosisBloc.state.gadgetValue;
  if (gadget != null) {
    gadget.disconnect();
    return;
  }
}

connectGadget(context) async {
  final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

  final connectedDevices = await flutterBlue.connectedDevices;
  for (var device in connectedDevices) {
    if (device.name == 'LieToGadget' || device.id.toString() == '7C:9E:BD:ED:7E:5E') {
      debugPrint('🐨 LIE TO GADGET ALREADY SYNC: ${device.id.toString()} ${device.name}');
      diagnosisBloc.add( SetGadget(device) );
      return;
    }
  }

  final gadget = diagnosisBloc.state.gadgetValue;
  if (gadget != null) {
    gadget.connect();
    return;
  }
  scanDevices(context);
}

scanDevices(context) async {
  final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);

  // bool isScanning = await flutterBlue.isScanning.last;
  // if (isScanning) {
  //   return;
  // }

  flutterBlue.startScan(timeout: const Duration(seconds: 6));

  flutterBlue.scanResults.listen((results) async {
    try {
      for (ScanResult r in results) {
        if (r.device.name == 'LieToGadget' || r.device.id.toString() == '7C:9E:BD:ED:7E:5E') {
          debugPrint('🐨 LIE TO GADGET SYNC: ${r.device.id.toString()} ${r.device.name}');
          diagnosisBloc.add( SetGadget(r.device) );
          await r.device.connect();
          flutterBlue.stopScan();
          return;
        } else {
          debugPrint('DEVICE FOUND: ' + r.device.name.toString());
        }
      }
    } catch (e) {
      flutterBlue.stopScan();
      debugPrint('🐻 ERROR SCANNING DEVICES: ' + e.toString());
    }
  });
}
  