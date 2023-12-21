import 'package:equatable/equatable.dart';
import 'package:trade_app/models/user_model.dart';

abstract class LoginEvent extends Equatable {}

class LoginSubmitEvent extends LoginEvent {
  UserModel loginModel;
  LoginSubmitEvent({required this.loginModel});
  @override
  List<Object?> get props => [loginModel];
}

class InitUserEvent extends LoginEvent {
  String msg;

  InitUserEvent({required this.msg});
  @override
  List<Object?> get props => [this.msg];
}
