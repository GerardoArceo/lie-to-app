import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:lie_to_app_2/bloc/app/app_bloc.dart';
import 'package:lie_to_app_2/bloc/diagnosis/diagnosis_bloc.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class CloudApiProvider {

  HttpClient client = HttpClient();

  String _getServerURL(BuildContext context) {
    final appBloc = BlocProvider.of<AppBloc>(context);
    final server = appBloc.state.apiURLValue ?? 'Lili';
    
    switch (server) {
      case 'Lili':
        return 'http://192.168.3.6:3003/';
      case 'Gera':
        return 'http://192.168.3.5:3003/';
      case 'LS':
        return 'https://liberatosoftware.com/lie-to-api/';
      default: 
        return 'https://liberatosoftware.com/lie-to-api/';
    }
  }

  Future sendDiagnosis(BuildContext context, String mode, {bool? fixedAnswer}) async {
    final diagnosisBloc = BlocProvider.of<DiagnosisBloc>(context);
    final appBloc = BlocProvider.of<AppBloc>(context);

    if (appBloc.state.isDiagnosisLite! == true) {
      final eyeTrackingResults = diagnosisBloc.state.eyeTrackingResultsValue ?? [];
      Map<String, String> data = {
        'eyeTrackingData': eyeTrackingResults.toString(),
      };
      if (fixedAnswer != null) data['fixedAnswer'] = fixedAnswer.toString();
      return sendPostRequest(context, 'diagnosisLite', data);
    }

    final audioPath = diagnosisBloc.state.audioPathValue;
    final bpmResults = diagnosisBloc.state.bpmResultsValue ?? [];
    final eyeTrackingResults = diagnosisBloc.state.eyeTrackingResultsValue ?? [];

    final url = _getServerURL(context);

    if (audioPath == null) return null;

    final user = FirebaseAuth.instance.currentUser!;
    final uri = Uri.parse(url + 'diagnosis');

    try {
      var request = http.MultipartRequest("POST", uri);

      File audioFile = File(audioPath);
      var stream = http.ByteStream(Stream.castFrom((audioFile.openRead())));
      final multipartFile = http.MultipartFile('audioFile', stream, audioFile.lengthSync(), filename: basename(audioPath));
      request.files.add(multipartFile);

      request.fields["mode"] = mode;
      request.fields["uid"] = user.uid;
      request.fields["bpmData"] = bpmResults.toString();
      request.fields["eyeTrackingData"] = eyeTrackingResults.toString();
      if (fixedAnswer != null) request.fields["fixedAnswer"] = fixedAnswer.toString();

      var response = await request.send();
      String reply = await response.stream.bytesToString();
      final decodeData = json.decode(reply);
      debugPrint('🐞 POST DIAGNOSIS RESPONSE: $decodeData');

      return decodeData;
      
    } catch (e) {
      debugPrint('🐞 POST DIAGNOSIS ERROR: $e');
      return null;
    }
  }

  Future sendPostRequest(BuildContext context, String endpoint, Map<String, String>  data) async{
    final url = _getServerURL(context);

    final user = FirebaseAuth.instance.currentUser!;
    data['uid'] = user.uid;

    try {
      Response response = await http.post(
        Uri.parse(url + endpoint),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      debugPrint('🐞 POST RESPONSE: ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('🐞 POST ERROR: $e');
      return null;
    }
  }

  Future sendGetRequest(BuildContext context, Map<String, String> data, String endpoint) async{
    final url = _getServerURL(context);

    final user = FirebaseAuth.instance.currentUser!;
    data['uid'] = user.uid;

    try {
      Response response = await http.get(
        Uri.parse(url + endpoint + '?' + data.entries.map((e) => '${e.key}=${e.value}').join('&')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      debugPrint('🐞 GET RESPONSE: ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('🐞 GET ERROR: $e');
      return null;
    }
  }
}