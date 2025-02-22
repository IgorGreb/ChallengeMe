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
      theme: ThemeData.light(),
      home: BlocProvider(
        create: (context) => CryptoBloc()..add(LoadCryptoList()),
        child: CryptoListPage(),
      ),
    );
  }
}
