// Імпортуємо необхідні бібліотеки та файли
import 'package:crypto_info/feautures/crypto_page/bloc/crypto_bloc.dart'; // Імпорт класу CryptoBloc для управління станом додатка
import 'package:crypto_info/feautures/crypto_page/presentation/screens/crypto_list.dart'; // Імпорт екрану зі списком криптовалют
import 'package:crypto_info/theme.dart'; // Імпорт теми для стилізації додатка
import 'package:flutter/material.dart'; // Імпорт базових віджетів Flutter
import 'package:flutter_bloc/flutter_bloc.dart'; // Імпорт бібліотеки flutter_bloc для роботи з Bloc-паттерном

// Основний віджет додатка
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Конструктор без параметрів для MyApp

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Основна тема для всього додатка
      theme:
          defaultTheme, // defaultTheme - це змінна, яка містить тему для додатка

      // Визначаємо головну сторінку додатка
      home: BlocProvider(
        // BlocProvider створює і надає CryptoBloc всім нащадкам цього віджета
        create: (context) => CryptoBloc()
          ..add(
              LoadCryptoList()), // Створюється об'єкт CryptoBloc і автоматично додається подія LoadCryptoList
        child:
            CryptoListPage(), // Віджет, що відповідає за відображення списку криптовалют
      ),
    );
  }
}
