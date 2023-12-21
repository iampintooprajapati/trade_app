import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:trade_app/bloc/login_bloc/login_event.dart';
import 'package:trade_app/bloc/login_bloc/login_state.dart';
import 'package:trade_app/repos/auth_repo.dart';
import 'package:trade_app/services/trade_store.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthRepo repo = AuthRepoImpl();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginSubmitEvent>(_onLoginSubmit);
  }

  _onLoginSubmit(LoginSubmitEvent event, Emitter<LoginState> emit) async {
    try {
      emit(LoginLoadingState());
      dynamic jsonData;
      jsonData = await repo.verifyLoginOtp(
          mobile: event.loginModel.mobile,
          countryCode: event.loginModel.countryCode);

      dynamic data = jsonData['data'];

       String token = data['token'];
          String refreshToken = "";
          String udata = jsonData.toString();
          tradeSharedStore.openSession(token, refreshToken, udata, true);
          emit(LoginSuccessState(msg: jsonData['message']));
      
    } on SocketException {
      emit(
        LoginErrorState(
          msg: "Something went wrong try again",
        ),
      );
    } catch (e) {
      emit(
        LoginErrorState(
          msg: e.toString(),
        ),
      );
    }
  }
}



// 0:
// "id" -> 195
// 1:
// "name" -> "Ravi Pandit"
// 2:
// "first_name" -> ""
// 3:
// "last_name" -> ""
// 4:
// "email" -> ""
// key:
// "email"
// value:
// ""
// 5:
// "country_short_code" -> ""
// 6:
// "country_code" -> "+91"
// 7:
// "mobile" -> "9106946953"
// 8:
// "profile_image" -> "http://hexeros.com/dev/finowise/uploads/user/user.png"
// 9:
// "refer_code" -> "Uta3oxhruARYzfE"
// 10:
// "notification_flag" -> "1"
// 11:
// "trade_count" -> 0
// 12:
// "token" -> "dYmX3ERVfSACzn2c09sASBYhaLO73VcLEydnF4xtFm3IuiSUuIXIxANBXvHpFDuY63cSTHVUyUTdotopcu5pv1sGeGppOiLmxkXG"
// 13:
// "social_login" -> 0