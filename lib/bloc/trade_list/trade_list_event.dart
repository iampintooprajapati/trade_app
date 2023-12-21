import 'package:equatable/equatable.dart';
import 'package:trade_app/models/trade_model.dart';

abstract class TradeListEvent extends Equatable {}

class FetchTradeListSummaryEvent extends TradeListEvent {
  @override
  List<Object?> get props => [];
}

class AddTradeListEvent extends TradeListEvent {
  TradeModel currentTaskModel;
  TradeModel changedTaskModel;

  AddTradeListEvent(
      {required this.changedTaskModel, required this.currentTaskModel});
  @override
  List<Object?> get props => [changedTaskModel, currentTaskModel];
}

class RemoveTradeListEvent extends TradeListEvent {
  TradeModel currentTaskModel;

  RemoveTradeListEvent({required this.currentTaskModel});
  @override
  List<Object?> get props => [currentTaskModel];
}

class FetchTradeListEvent extends TradeListEvent {
  String? type;
  bool isLoad;

  FetchTradeListEvent({this.isLoad = true, required this.type});
  @override
  List<Object?> get props => [isLoad, type];
}

class FetchNextTradeListEvent extends TradeListEvent {
  String? type;
  FetchNextTradeListEvent({required this.type});
  @override
  List<Object?> get props => [type];
}