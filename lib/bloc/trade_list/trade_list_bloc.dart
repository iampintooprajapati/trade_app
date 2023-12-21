import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:http/http.dart" as http;
import 'package:trade_app/bloc/trade_list/trade_list_event.dart';
import 'package:trade_app/bloc/trade_list/trade_list_state.dart';
import 'package:trade_app/models/trade_model.dart';
import 'package:trade_app/repos/trade_repo.dart';

class TradeListBloc extends Bloc<TradeListEvent, TradeListState> {
  TradeRepo repo;
  int page = 1;
  TradeListBloc({required this.repo}) : super(TradeListInitialState()) {
    on<FetchTradeListEvent>(_onFetchTradeListEvent);
    on<FetchNextTradeListEvent>(_onFetchNextTradeListEvent);
  }

  _onFetchTradeListEvent(
    FetchTradeListEvent event,
    Emitter<TradeListState> emit,
  ) async {
    try {
      if (event.isLoad) {
        emit(TradeListLoadingState());
      }
      page = 1;
      http.Response response =
          await repo.fetchTradeList(page, event.type ?? "ongoing");
      dynamic jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        if (jsonData['status'] == 200) {
          List<TradeModel> projectList =
              List.from(((jsonData['data'] as List).map(
            (e) => TradeModel.fromJson(e),
          )));
          if (projectList.isEmpty) {
            emit(NoTradeListState());
            return;
          }
          page = page + 1;
          emit(
            TradeListLoadedState(
              // hasReachmax: !(event.isLoad),
              hasReachmax:
                  event.isLoad == false ? true : !(projectList.length >= 6),
              projectModel: projectList,
            ),
          );
        } else {
          emit(TradeListErrorState(msg: "Something went wrong"));
        }
      } else {
        if (response.statusCode == 401) {
          emit(TradeListErrorState(msg: "Session Expired"));
        } else {
          emit(TradeListErrorState(msg: "Something went wrong"));
        }
      }
    } on SocketException {
      emit(TradeListNoInternetState());
    } catch (e) {
      emit(TradeListErrorState(msg: "Something went wrong"));
    }
  }

  _onFetchNextTradeListEvent(
      FetchNextTradeListEvent event, Emitter<TradeListState> emit) async {
    try {
      if (state is TradeListLoadedState) {
        emit(
          TradeListLoadedState(
            ontrack: (state as TradeListLoadedState).ontrack,
            completed: (state as TradeListLoadedState).completed,
            delayed: (state as TradeListLoadedState).delayed,
            projectModel: (state as TradeListLoadedState).projectModel,
            hasReachmax: false,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        // return;
        http.Response response =
            await repo.fetchTradeList(page, event.type ?? "ongoing");
        dynamic jsonData = jsonDecode(utf8.decode(response.bodyBytes));
        if (response.statusCode == 200) {
          if (jsonData['status'] == 200) {
            List<TradeModel> projectList = List.from(
              ((jsonData['data'] as List).map((e) => TradeModel.fromJson(e))),
            );
            emit(
              TradeListLoadedState(
                ontrack: (state as TradeListLoadedState).ontrack,
                completed: (state as TradeListLoadedState).completed,
                delayed: (state as TradeListLoadedState).delayed,
                projectModel:
                    (state as TradeListLoadedState).projectModel + projectList,
                hasReachmax: true,
              ),
            );
            if (projectList.isNotEmpty) {
              page = page + 1;
            }
          } else {
            emit(TradeListErrorState(msg: "Something went wrong"));
          }
        } else {
          if (response.statusCode == 401) {
            emit(TradeListErrorState(msg: "Session Expired"));
          } else {
            emit(TradeListErrorState(msg: "Something went wrong"));
          }
        }
      } else {
        emit(state);
      }
    } on SocketException catch (e) {
      emit(TradeListNoInternetState());
    } catch (e) {
      emit(TradeListErrorState(msg: "Something went wrong"));
    }
  }
}
