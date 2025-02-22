part of 'crypto_bloc.dart';

abstract class CryptoEvent {}

class LoadCryptoList extends CryptoEvent {}

class LoadCryptoDetails extends CryptoEvent {
  final String id;
  LoadCryptoDetails(this.id);
}
