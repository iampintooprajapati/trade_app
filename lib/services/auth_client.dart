import 'dart:convert';
import "package:http/http.dart" as http;

class AuthClient {
  static final AuthClient instance = AuthClient._internal();

  factory AuthClient() {
    return instance;
  }

  AuthClient._internal();
  doGet(String url, Map<String, String> header) {
    return http.get(Uri.parse(url), headers: header);
  }

  Future<http.Response> doPost(String url, Map<String, dynamic> body,
      {Map<String, String>? header}) {
    Map<String, String> head = {"content-type": "application/json"};
    if (header != null) {
      head.addAll(header);
    }
    String data = json.encode(body);
    return http.post(Uri.parse(url),
        body: jsonEncode({"info": data}), headers: head);
  }

  Future<http.Response> doPostForm(String url,Map<String,String> body) async {
    var request = http.MultipartRequest("POST",Uri.parse(url));
    request.fields.addAll(body);

   http.StreamedResponse response1 = await request.send();
     return   http.Response.fromStream(response1);

  }

  Future<http.Response> doAuth(String url, Object body,
      {Map<String, String>? header}) {
    Map<String, String> head = {"content-type": "application/json"};
    if (header != null) {
      head.addAll(header);
    }
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: head);
  }
}
