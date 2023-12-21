import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TradeSharedStore {
  final String userTokenKey = "user_token";
  final String refreshTokenKey = "refresh_token";
  final String userDataKey = "user_data";
  final String userLangKey = "user_lang";
  final String profileCompletedKey = "profile_completed";
  final String langDate = "lang_date";
  final String boxLangKey = "lang_content";

  final PublishSubject<bool> _isSessionValid = PublishSubject<bool>();
  Stream<bool> get isSessionValid => _isSessionValid.stream;

  void dispose() {
    _isSessionValid.close();
  }

  //Open session when new token is got
  void openSession(String userToken, String refreshToken,
      [String? userData, bool isProfileCompleted = true]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(userTokenKey, userToken);
    await prefs.setString(refreshTokenKey, refreshToken);
    await prefs.setBool(profileCompletedKey, isProfileCompleted);
    if (userData != null) {
      await prefs.setString(userDataKey, userData);
    }
    bool session = await isSession();
    if (session) {
      _isSessionValid.sink.add(true);
    }
  }


  //close the session when there is no longer user available
  Future<bool> closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isContain = prefs.containsKey(userTokenKey);
    if (isContain) {
      bool isUserTokenRemoved = await prefs.remove(userTokenKey);
      await prefs.remove(refreshTokenKey);
      await prefs.remove(userDataKey);
      await prefs.remove(userLangKey);
      await prefs.remove(profileCompletedKey);
      if (isUserTokenRemoved) {
        _isSessionValid.sink.add(false);
        return true;
      } else {
        _isSessionValid.sink.add(true);
        return false;
      }
    } else {
      return false;
    }
  }

  //resore the session
  void restoreSession() async {
    bool session = await isSession();

    if (session) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }

  //Check is accesstoken is available
  Future<bool> isSession() async {
    String? sessionKey = await getSessionKey();
    if (sessionKey != "" && sessionKey != null) {
      return true;
    }
    return false;
  }

  //Get the stored accesstoken
  Future<String?> getSessionKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isContainKey = prefs.containsKey(userTokenKey);
    if (isContainKey) {
      String? userToken = prefs.getString(userTokenKey);
      return userToken;
    }
    return null;
  }

  //Getting stored refresh token
  Future<String?> getRefreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isContainKey = prefs.containsKey(refreshTokenKey);
    if (isContainKey) {
      String? refreshToken = prefs.getString(refreshTokenKey);
      return refreshToken;
    }
    return null;
  }

  //Store user language in the formate of en_GB | hi_IN

 
}

TradeSharedStore tradeSharedStore = TradeSharedStore();
