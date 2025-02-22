import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_info/bloc/crypto_bloc.dart';
import 'package:crypto_info/presentation/screens/crypto_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Основна тема для всього додатка
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Тло для всього додатку
        appBarTheme: AppBarTheme(
          color: Colors.white, // Колір апбару
          elevation: 0, // Без тіні
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      home: BlocProvider(
        create: (context) => CryptoBloc()..add(LoadCryptoList()),
        child: CryptoListPage(),
      ),
    );
  }
}
