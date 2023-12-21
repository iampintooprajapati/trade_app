import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trade_app/services/api_constant.dart';
import 'package:trade_app/services/auth_client.dart';

abstract class AuthRepo {
  Future<dynamic> verifyLoginOtp(
      {String? mobile, String? countryCode, String? otp});
}

class AuthRepoImpl extends AuthRepo {
  @override
  Future<dynamic> verifyLoginOtp({
    String? mobile,
    String? countryCode,
    String? otp,
  }) async {
    Map<String, String> body = {
      "otp": "1245",
      'mobile': mobile ?? "",
      'country_code': countryCode ?? "",
      'device_id': "122",
      'device_type':"android",
    };

    http.Response response =
        await AuthClient.instance.doPostForm(ApiConstant.login, body);

    dynamic jsonData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (jsonData['status'] == 200 ) {
        return jsonData;
      } else {
        throw Exception(jsonData['message']);
      }
    } else {
      throw Exception(jsonData['message']);
    }
  }
}
