import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinorm_task/features/authentication/bloc/login_bloc.dart';
import 'package:qurinorm_task/features/authentication/presentation/loginpage.dart';
import 'package:qurinorm_task/features/chatlist/bloc/chat_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => ChatBloc()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuriNorm Task',
      home: BlocProvider(create: (_) => LoginBloc(), child: const LoginPage()),
    );
  }
}
