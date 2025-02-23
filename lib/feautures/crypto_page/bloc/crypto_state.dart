part of 'crypto_bloc.dart';

// Абстрактний клас для всіх станів, які використовуються в BLoC
abstract class CryptoState {}

// Стан, коли дані криптовалют ще завантажуються
class CryptoLoading extends CryptoState {}

// Стан, коли дані криптовалют успішно завантажено
class CryptoLoaded extends CryptoState {
  final List<Map<String, dynamic>> cryptoList; // Список криптовалют
  CryptoLoaded(
      this.cryptoList); // Конструктор для ініціалізації списку криптовалют
}

// Стан, коли сталася помилка при завантаженні даних
class CryptoError extends CryptoState {
  final String errorMessage; // Повідомлення про помилку
  CryptoError(
      {this.errorMessage =
          'Невідома помилка.'}); // Конструктор для ініціалізації повідомлення про помилку
}
