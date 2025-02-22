import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'crypto_event.dart';
part 'crypto_state.dart';

// Bloc
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  // Кешування даних
  List<Map<String, dynamic>> cryptoListCache = [];
  Map<String, dynamic> cryptoDetailsCache = {};

  CryptoBloc() : super(CryptoLoading()) {
    on<LoadCryptoList>(_loadCryptoList);
    on<LoadCryptoDetails>(_loadCryptoDetails);
  }

  // Завантаження списку криптовалют
  Future<void> _loadCryptoList(
      LoadCryptoList event, Emitter<CryptoState> emit) async {
    try {
      if (cryptoListCache.isNotEmpty) {
        // Якщо криптовалюти вже завантажені, просто повертаємо їх з кешу
        emit(CryptoLoaded(cryptoListCache));
      } else {
        emit(CryptoLoading());

        final response = await http.get(
          Uri.parse(
              'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          cryptoListCache = List<Map<String, dynamic>>.from(data);
          emit(CryptoLoaded(cryptoListCache));
        } else {
          emit(CryptoError(errorMessage: 'Failed to load crypto list.'));
        }
      }
    } catch (e) {
      emit(CryptoError(errorMessage: e.toString()));
    }
  }

  // Завантаження деталей криптовалюти
  Future<void> _loadCryptoDetails(
      LoadCryptoDetails event, Emitter<CryptoState> emit) async {
    try {
      if (cryptoDetailsCache.containsKey(event.id)) {
        // Return cached data if available
        emit(CryptoDetailsLoaded(cryptoDetailsCache[event.id]!));
      } else {
        final response = await http.get(
          Uri.parse(
              'https://api.coingecko.com/api/v3/coins/${event.id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true'),
        );

        // Логування для перевірки відповіді API
        if (kDebugMode) {
          print('Response status: ${response.statusCode}');
          print('Response body: ${response.body}');
        }

        // Перевірка статусу відповіді
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          cryptoDetailsCache[event.id] = data; // Cache the details
          emit(CryptoDetailsLoaded(data));
        } else {
          if (kDebugMode) {
            print('API returned an error: ${response.statusCode}');
          }
          emit(CryptoError(errorMessage: 'Failed to load crypto details.'));
        }
      }
    } catch (e) {
      // Логування для помилок
      if (kDebugMode) {
        print('Error loading crypto details: $e');
      }
      emit(CryptoError(errorMessage: e.toString()));
    }
  }
}
