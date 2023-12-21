import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:trade_app/services/trade_store.dart';

class UserClient {
  static final UserClient instance = UserClient._internal();

  factory UserClient() {
    return instance;
  }

  UserClient._internal();
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

  Future<http.Response> doPostForm(String url, Map<String, String> body) async {
    String? token = await tradeSharedStore.getSessionKey();
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.headers.addAll({
      "vAuthorization": "Bearer $token",
    });
    request.fields.addAll(body);

    http.StreamedResponse response1 = await request.send();
    return http.Response.fromStream(response1);
  }

  Future<http.Response> doUser(String url, Object body,
      {Map<String, String>? header}) {
    Map<String, String> head = {"content-type": "application/json"};
    if (header != null) {
      head.addAll(header);
    }
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: head);
  }
}
