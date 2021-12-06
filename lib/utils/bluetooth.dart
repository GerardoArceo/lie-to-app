import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';

  FlutterBlue flutterBlue = FlutterBlue.instance;

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
        print('🐨 LIE TO GADGET ALREADY SYNC: ${device.id.toString()} ${device.name}');
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
            print('🐨 LIE TO GADGET SYNC: ${r.device.id.toString()} ${r.device.name}');
            diagnosisBloc.add( SetGadget(r.device) );
            await r.device.connect();
            flutterBlue.stopScan();
            return;
          } else {
            print('DEVICE FOUND: ' + r.device.name.toString());
          }
        }
      } catch (e) {
        flutterBlue.stopScan();
        print('🐻 ERROR SCANNING DEVICES: ' + e.toString());
      }
    });

  }
  