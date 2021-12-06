// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class CloudApiProvider {

  HttpClient client = HttpClient();
  // final url ='https://liberatosoftware.com/lie-to-api/';
  final url ='http://192.168.3.5:3003/';

  sendDiagnosis(String? audioPath, List<int> bpm, List<int> eyeTrackingResults, String mode) async{
    if (audioPath == null) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final uri = Uri.parse(url + 'diagnosis');

    try {
      var request = http.MultipartRequest("POST", uri);

      File audioFile = File(audioPath);
      var stream = http.ByteStream(Stream.castFrom((audioFile.openRead())));
      final multipartFile = http.MultipartFile('myFile', stream, audioFile.lengthSync(), filename: basename(audioPath));
      request.files.add(multipartFile);

      request.fields["mode"] = mode;
      request.fields["uid"] = user.uid;
      request.fields["heartData"] = bpm.toString();
      request.fields["eyeTrackingData"] = eyeTrackingResults.toString();

      var response = await request.send();
      String reply = await response.stream.bytesToString();
      final decodeData = json.decode(reply);
      print('🐞 POST RESPONSE: $decodeData');

      return decodeData;
      
    } catch (e) {
      print('🐞 POST ERROR: $e');
      return null;
    }
  }

  sendPostRequest(Map<String, String>  data, String endpoint) async{
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
      print('POST RESPONSE: ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }

  sendGetRequest(Map<String, String>  data, String endpoint) async{
    final user = FirebaseAuth.instance.currentUser!;
    data['uid'] = user.uid;

    try {
      Response response = await http.get(
        Uri.parse(url + endpoint + '?' + data.entries.map((e) => '${e.key}=${e.value}').join('&')),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('GET RESPONSE: ${jsonDecode(response.body)}');
      return jsonDecode(response.body);
    } catch (e) {
      print(e);
      return null;
    }
  }
}