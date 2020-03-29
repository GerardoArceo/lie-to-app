import 'dart:convert';
import 'dart:io';

import 'package:lie_to_app/src/preferences/user_prefs.dart';

class CloudApiProvider {

  final prefs = new UserPrefs();
  HttpClient client = new HttpClient();
  final url ='https://gerardoarceo.com:3000/';

  sendTest() async {
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
  }

  sendDiagnosis(Map<String, String>  data) async{
    data['action'] = 'diagnosis';
    data['uid'] = prefs.uid.toString();

    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.postUrl(Uri.parse(url + 'diagnosis'));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(data)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(reply);
      return decodeData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  sendRetroalimentation(Map<String, String>  data) async{
    data['action'] = 'retroalimentation';

    try {
      client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      HttpClientRequest request = await client.postUrl(Uri.parse(url + 'retroalimentation'));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(data)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();
      final decodeData = json.decode(reply);
      return decodeData;
    } catch (e) {
      print(e);
      return null;
    }
  }

}