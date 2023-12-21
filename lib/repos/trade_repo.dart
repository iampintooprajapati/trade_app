import 'package:http/http.dart' as http;
import 'package:trade_app/services/api_constant.dart';
import 'package:trade_app/services/user_client.dart';

abstract class TradeRepo {
  Future<http.Response> fetchTradeList(int page, String filter);
}

class TradeRepoImpl extends TradeRepo {
  @override
  Future<http.Response> fetchTradeList(int page, String filter) {
    String url = ApiConstant.tradeList;
    return UserClient.instance
        .doPostForm(url, {"filters": filter, "limit": "10", "offset": "$page"});
  }
}
