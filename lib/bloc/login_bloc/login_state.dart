import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {}

class LoginNoInternetState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginInitialState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccessState extends LoginState {
  String msg;
  LoginSuccessState({required this.msg});
  @override
  List<Object?> get props => [msg];
}

class LoginLoadingState extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginErrorState extends LoginState {
  String msg;
  LoginErrorState({required this.msg});
  @override
  List<Object?> get props => [msg];
  @override
  String toString() {
    return msg;
  }
}
