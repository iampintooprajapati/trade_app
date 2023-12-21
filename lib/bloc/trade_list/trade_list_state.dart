import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:trade_app/models/trade_model.dart';

abstract class TradeListState extends Equatable {}

class TradeListInitialState extends TradeListState {
  @override
  List<Object?> get props => [];
}

class TradeListLoadingState extends TradeListState {
  @override
  List<Object?> get props => [];
}

class NoTradeListState extends TradeListState {
  @override
  List<Object?> get props => [];
}

class TradeListLoadedState extends TradeListState {
  late List<TradeModel> projectModel;
  bool hasReachmax;
  int delayed, ontrack, completed;

  TradeListLoadedState(
      {required this.projectModel,
      this.hasReachmax = false,
      this.delayed = 0,
      this.ontrack = 0,
      this.completed = 0});
  @override
  List<Object?> get props => [
        projectModel,
        hasReachmax,
        delayed,
        ontrack,
        completed,
        Random().nextDouble()
      ];
}

class TradeListCompleteProfile extends TradeListState {
  String? msg;
  TradeListCompleteProfile({this.msg});
  @override
  List<Object?> get props => [msg];
}

class TradeListErrorState extends TradeListState {
  String? msg;
  TradeListErrorState({this.msg});
  @override
  List<Object?> get props => [msg];
}

class TradeListNoInternetState extends TradeListState {
  @override
  List<Object?> get props => [];
}
