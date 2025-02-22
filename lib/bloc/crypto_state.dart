part of 'crypto_bloc.dart';

// Bloc State
abstract class CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<dynamic> cryptoList;
  CryptoLoaded(this.cryptoList);
}

class CryptoDetailsLoaded extends CryptoState {
  final Map<String, dynamic> cryptoDetails;
  CryptoDetailsLoaded(this.cryptoDetails);
}

class CryptoError extends CryptoState {}
