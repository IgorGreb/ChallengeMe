part of 'crypto_bloc.dart'; // Вказує на те, що цей файл є частиною файлу crypto_bloc.dart

// Абстрактний клас, який описує події для BLoC
abstract class CryptoEvent {}

// Клас події для завантаження списку криптовалют
class LoadCryptoList extends CryptoEvent {}
