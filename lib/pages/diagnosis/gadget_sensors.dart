import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'sensor_chart.dart';

class GadgetSensors extends StatefulWidget {
  const GadgetSensors({Key? key}) : super(key: key);

  @override
  GadgetSensorsView createState() {
    return GadgetSensorsView();
  }
}

class GadgetSensorsView extends State<GadgetSensors> with SingleTickerProviderStateMixin {
  final List<SensorValue> _eyeTrackingData = []; // array to store the values
  final List<SensorValue> _heartRateData = []; // array to store the values
  final int _windowLen = 30 * 4; // window length to display - 6 seconds
  final int _windowLen2 = 30 * 2; // window length to display - 6 seconds
  late BluetoothCharacteristic eyeTrackingCharacteristic;
  late BluetoothCharacteristic heartRateCharacteristic;

  bool isWidgetActive = true;

  int _bpm = 0; // beats per minute
  final int _fs = 30; // sampling frequency (fps)
  final double _alpha = 0.3; // factor for the mean value

  @override
  void initState() {
    super.initState();

    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    diagnosisBloc.state.diagnosisOnProgress.stream.listen((diagnosisOnProgress) {
      if (diagnosisOnProgress) {
        _startReceiveGadgetData(context);
      } else {
        isWidgetActive = false;
        diagnosisBloc.add(SetBpm(_bpm));
        eyeTrackingCharacteristic.setNotifyValue(false);
        heartRateCharacteristic.setNotifyValue(false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    isWidgetActive = false;
    // final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    // diagnosisBloc.add(SetBpm(_bpm));
    // eyeTrackingCharacteristic.setNotifyValue(false);
    // heartRateCharacteristic.setNotifyValue(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Eye Tracking Sensor",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Colors.black),
              child: SensorChart(_eyeTrackingData),
            ),
          ),
          const SizedBox(
            width: 200.0,
            height: 50.0,
          ),
          const Text(
            "Estimated BPM",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            // (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
            _bpm.toString(),
            style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
              color: Colors.black),
              child: SensorChart(_heartRateData),
            ),
          ),
      ],
    );
  }

  _startReceiveGadgetData(context) async {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    final gadget = diagnosisBloc.state.gadgetValue;
    final eyeTrackingResults = diagnosisBloc.state.eyeTrackingResultsValue ?? [];
    final bpmResults = diagnosisBloc.state.bpmResultsValue ?? [];
    if (gadget == null) return;

    List<BluetoothService> services;
    try {
      services = await gadget.discoverServices();
    } catch (e) {
      print(e);
      return;
    }

    for (var service in services) {
      for (var c in service.characteristics) {
        print('ID CARACTERISTICA 🦊' + c.uuid.toString());
        if (c.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // eye tracking
          eyeTrackingCharacteristic = c;
          eyeTrackingCharacteristic.setNotifyValue(true);
          eyeTrackingCharacteristic.value.listen((value) {
            final v = value.map((data) {
              if (data.isNaN || data == 0) return '';
              return data - 48;
            }).join();
            if (_eyeTrackingData.length >= _windowLen) {
              _eyeTrackingData.removeAt(0);
            }
            if (isWidgetActive) {
              setState(() {
                _eyeTrackingData.add(SensorValue(DateTime.now(), 255 - double.parse(v)));
              });
            }
            eyeTrackingResults.add(int.parse(v));
          });
        }
        if (c.uuid.toString() == '7a807eb0-5583-11ec-bf63-0242ac130002') { // heart rate
          heartRateCharacteristic = c;
          heartRateCharacteristic.setNotifyValue(true);
          _updateBPM();
          heartRateCharacteristic.value.listen((value) {
            final v = value.map((data) {
              if (data.isNaN || data == 0) return '';
              return data - 48;
            }).join();
            if (_heartRateData.length >= _windowLen2) {
              _heartRateData.removeAt(0);
            }
            if (isWidgetActive) {
              setState(() {
                _heartRateData.add(SensorValue(DateTime.now(), 255 - double.parse(v)));
              });
            }
            bpmResults.add(int.parse(v));
          });
        }
       
      }
    }
  }



   void _updateBPM() async {
    // Bear in mind that the method used to calculate the BPM is very rudimentar
    // feel free to improve it :)

    // Since this function doesn't need to be so "exact" regarding the time it executes,
    // I only used the a Future.delay to repeat it from time to time.
    // Ofc you can also use a Timer object to time the callback of this function
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;

    while (true) {
      _values = List.from(_heartRateData); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      _values.forEach((SensorValue value) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      });
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        print(_bpm);
        if (isWidgetActive) {
          setState(() {
            this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
          });
        }
      }
      await Future.delayed(Duration(
          milliseconds:
              5000 * 3 ~/ _fs)); // wait for a new set of _data values
    }
  }
}
