import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_app/bloc/login_bloc/logic_bloc.dart';
import 'package:trade_app/bloc/trade_list/trade_list_bloc.dart';
import 'package:trade_app/repos/trade_repo.dart';
import 'package:trade_app/ui/login/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(create: (context) => TradeListBloc(repo: TradeRepoImpl()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trade App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
