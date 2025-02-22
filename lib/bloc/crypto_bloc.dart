import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'crypto_event.dart';
part 'crypto_state.dart';

// Bloc
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  CryptoBloc() : super(CryptoLoading()) {
    on<LoadCryptoList>(_loadCryptoList);
    on<LoadCryptoDetails>(_loadCryptoDetails);
  }

  Future<void> _loadCryptoList(
      LoadCryptoList event, Emitter<CryptoState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true'),
      );
      final data = json.decode(response.body);
      emit(CryptoLoaded(data));
    } catch (_) {
      emit(CryptoError());
    }
  }

  Future<void> _loadCryptoDetails(
      LoadCryptoDetails event, Emitter<CryptoState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/${event.id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true'),
      );
      final data = json.decode(response.body);
      emit(CryptoDetailsLoaded(data));
    } catch (_) {
      emit(CryptoError());
    }
  }
}
