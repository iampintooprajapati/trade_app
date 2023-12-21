import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_app/bloc/trade_list/trade_list_bloc.dart';
import 'package:trade_app/bloc/trade_list/trade_list_event.dart';
import 'package:trade_app/services/trade_store.dart';
import 'package:trade_app/ui/login/login_screen.dart';
import 'package:trade_app/widgets/custom_serach.dart';
import 'package:trade_app/widgets/trade_card.dart';

import '../../bloc/trade_list/trade_list_state.dart';
import '../../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TradeListBloc tradeListBloc;
  late TabController tabController;
  late ScrollController scrollCtr;
  late ScrollController scrollCtr2;

  @override
  void initState() {
    scrollCtr = ScrollController();
    scrollCtr2 = ScrollController();
    tradeListBloc = context.read<TradeListBloc>();
    tradeListBloc.add(FetchTradeListEvent(type: "ongoing"));
    tabController = TabController(length: 2, vsync: this);
    super.initState();

    scrollCtr.addListener(
      () {
        if (scrollCtr.position.atEdge) {
          if (scrollCtr.position.pixels == scrollCtr.position.maxScrollExtent) {
            tradeListBloc.add(FetchNextTradeListEvent(
                type: tabController.index == 0 ? "ongoing" : "expired"));
          }
        }
      },
    );

    scrollCtr2.addListener(
      () {
        if (scrollCtr.position.atEdge) {
          if (scrollCtr.position.pixels == scrollCtr.position.maxScrollExtent) {
            tradeListBloc.add(FetchNextTradeListEvent(
                type: tabController.index == 0 ? "ongoing" : "expired"));
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
        backgroundColor: AppColors.blue,
        automaticallyImplyLeading: false,
        title: const Text(
          "Trade Recommended",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                bool isDone = await tradeSharedStore.closeSession();
                if (isDone == false) {
                  return;
                }
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Material(
              color: AppColors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.50),
                  onTap: (index) {
                    tradeListBloc.add(FetchTradeListEvent(
                        type: index == 0 ? "ongoing" : "expired"));
                  },
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: "Ongoing",
                    ),
                    Tab(
                      text: "Expired",
                    ),
                  ]),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: CustomInput(
              hint: "Search by stock or mentor name",
              suffixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              BlocBuilder<TradeListBloc, TradeListState>(
                builder: (context, state) {
                  if (state is TradeListLoadingState ||
                      state is TradeListInitialState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TradeListErrorState) {
                    if (state.msg == "Session Expired") {
                      return Center(
                        child: SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                bool isDone =
                                    await tradeSharedStore.closeSession();
                                if (isDone == false) {
                                  return;
                                }
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              },
                              child: const Text("Go Login")),
                        ),
                      );
                    }
                    return Center(
                      child: Text(state.msg ?? "Error while loading"),
                    );
                  }
                  if (state is NoTradeListState) {
                    return const Center(
                      child: Text("Trades Not Available"),
                    );
                  }
                  if (state is TradeListLoadedState) {
                    return ListView.builder(
                        controller: scrollCtr,
                        itemCount: state.projectModel.length,
                        itemBuilder: (context, index) {
                          return TradeCard(
                              tradeModel: state.projectModel[index]);
                        });
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<TradeListBloc, TradeListState>(
                builder: (context, state) {
                  if (state is TradeListLoadingState ||
                      state is TradeListInitialState) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TradeListErrorState) {
                    if (state.msg == "Session Expired") {
                      return Center(
                        child: SizedBox(
                          height: 40,
                          width: 200,
                          child: ElevatedButton(
                              onPressed: () async {
                                bool isDone =
                                    await tradeSharedStore.closeSession();
                                if (isDone == false) {
                                  return;
                                }
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              child: const Text("Go Login")),
                        ),
                      );
                    }
                    return const Center(
                      child: Text("Error while loading"),
                    );
                  }
                  if (state is NoTradeListState) {
                    return const Center(
                      child: Text("Trades Not Available"),
                    );
                  }
                  if (state is TradeListLoadedState) {
                    return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        controller: scrollCtr2,
                        itemCount: state.projectModel.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TradeCard(
                                tradeModel: state.projectModel[index]),
                          );
                        });
                  }
                  return const SizedBox();
                },
              ),
            ]),
          )
        ],
      ),
    );
  }
}
