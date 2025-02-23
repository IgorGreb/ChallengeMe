import 'dart:convert'; // Для роботи з JSON
import 'package:flutter/foundation.dart'; // Для дебаг-режиму
import 'package:flutter_bloc/flutter_bloc.dart'; // Для використання BLoC
import 'package:http/http.dart' as http; // Для виконання HTTP-запитів

// Підключаємо файли зі станами та подіями для CryptoDetailBloc
part 'crypto_detail_state.dart';
part 'crypto_detail_event.dart';

// BLoC клас для обробки подій та станів, пов'язаних із деталями криптовалюти
class CryptoDetailBloc extends Bloc<CryptoDetailEvent, CryptoDetailState> {
  // Локальний кеш для збереження деталей криптовалюти
  Map<String, dynamic> cryptoDetailsCache = {};

  // Конструктор BLoC, що ініціалізує початковий стан як CryptoDetailLoading
  CryptoDetailBloc() : super(CryptoDetailLoading()) {
    // Оголошуємо обробник події LoadCryptoDetails
    on<LoadCryptoDetails>(
        _loadCryptoDetails); // Визначаємо, яку функцію викликати при цій події
  }

  // Функція для завантаження деталей криптовалюти
  Future<void> _loadCryptoDetails(
      LoadCryptoDetails event, Emitter<CryptoDetailState> emit) async {
    try {
      // Перед тим, як завантажувати нові дані, виводимо стан завантаження
      emit(CryptoDetailLoading());

      // Перевіряємо, чи є дані в кеші для цього ID
      if (cryptoDetailsCache.containsKey(event.id)) {
        // Якщо є, емітуємо стан з кешованими даними
        emit(CryptoDetailsLoaded(cryptoDetailsCache[event.id]!));
      } else {
        // Якщо кеша немає, робимо запит до API
        final response = await http.get(
          Uri.parse(
              'https://api.coingecko.com/api/v3/coins/${event.id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true'),
        );

        // Логування відповіді API для дебагу (тільки в режимі розробки)
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        // Перевіряємо статус відповіді (успіх або помилка)
        if (response.statusCode == 200) {
          // Якщо статус 200 (успішно), парсимо дані з JSON
          final data = json.decode(response.body);

          // Кешуємо отримані дані для подальших запитів
          cryptoDetailsCache[event.id] = data;

          // Емітуємо стан з завантаженими даними
          emit(CryptoDetailsLoaded(data));
        } else {
          // Якщо статус не 200, виводимо помилку
          if (kDebugMode) {
            print('API returned an error: ${response.statusCode}');
          }
          // Виводимо помилку користувачу
          emit(CryptoDetailError(
              errorMessage: 'Failed to load crypto details.'));
        }
      }
    } catch (e) {
      // Ловимо всі можливі помилки (наприклад, проблеми з мережею)
      if (kDebugMode) {
        print('Error loading crypto details: $e');
      }
      // Виводимо помилку
      emit(CryptoDetailError(errorMessage: e.toString()));
    }
  }
}
