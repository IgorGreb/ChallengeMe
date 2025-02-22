part of 'crypto_bloc.dart';

// States
abstract class CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<Map<String, dynamic>> cryptoList;
  CryptoLoaded(this.cryptoList);
}

class CryptoDetailsLoaded extends CryptoState {
  final Map<String, dynamic> cryptoDetails;
  CryptoDetailsLoaded(this.cryptoDetails);
}

class CryptoError extends CryptoState {
  final String errorMessage;
  CryptoError({this.errorMessage = 'An unknown error occurred.'});
}
