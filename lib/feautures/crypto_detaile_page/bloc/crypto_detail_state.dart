part of 'crypto_detail_bloc.dart';

// Абстрактний клас для станів, пов'язаних з деталями криптовалюти
abstract class CryptoDetailState {}

// Стан, що вказує на процес завантаження даних криптовалюти
class CryptoDetailLoading extends CryptoDetailState {}

// Стан, що вказує на успішне завантаження даних криптовалюти
class CryptoDetailsLoaded extends CryptoDetailState {
  // Дані про криптовалюту, що завантажено
  final Map<String, dynamic> cryptoDetails;

  // Конструктор для ініціалізації стану з даними про криптовалюту
  CryptoDetailsLoaded(this.cryptoDetails);
}

// Стан, що вказує на помилку при завантаженні даних криптовалюти
class CryptoDetailError extends CryptoDetailState {
  // Повідомлення про помилку
  final String errorMessage;
  // Код статусу, якщо є
  final int? statusCode;

  // Конструктор для ініціалізації стану з повідомленням про помилку та кодом статусу
  CryptoDetailError({
    this.errorMessage =
        'Не відома помилка', // За замовчуванням повідомлення про невідому помилку
    this.statusCode, // Статус код відповіді
  });

  // Перевизначення методу toString для зручного виведення інформації про помилку
  @override
  String toString() {
    return 'Error: $errorMessage${statusCode != null ? ' (Status Code: $statusCode)' : ''}';
  }
}
