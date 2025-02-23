// Підключаємо частину файлу для зв'язку з основним BLoC класом
part of 'crypto_detail_bloc.dart';

// Абстрактний клас для подій, пов'язаних з деталями криптовалюти
abstract class CryptoDetailEvent {}

// Подія, що ініціює завантаження деталей криптовалюти
class LoadCryptoDetails extends CryptoDetailEvent {
  // Ідентифікатор криптовалюти, для якої потрібно завантажити деталі
  final String id;

  // Конструктор для ініціалізації об'єкта LoadCryptoDetails з обов'язковим параметром id
  LoadCryptoDetails({required this.id});
}
