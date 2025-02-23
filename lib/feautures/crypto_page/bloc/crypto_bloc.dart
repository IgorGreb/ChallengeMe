import 'dart:convert'; // Імпорт бібліотеки для роботи з JSON
import 'package:flutter_bloc/flutter_bloc.dart'; // Імпорт бібліотеки для використання BLoC в Flutter
import 'package:http/http.dart' as http; // Імпорт бібліотеки для HTTP запитів

part 'crypto_event.dart'; // Частина для подій (CryptoEvent)
part 'crypto_state.dart'; // Частина для станів (CryptoState)

// Bloc клас для керування станом криптовалют
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  // Кешування даних про криптовалюти
  List<Map<String, dynamic>> cryptoListCache = [];

  // Конструктор, який ініціалізує стан завантаження
  CryptoBloc() : super(CryptoLoading()) {
    // Реєстрація обробника події LoadCryptoList
    on<LoadCryptoList>(_loadCryptoList);
  }

  // Завантаження списку криптовалют
  Future<void> _loadCryptoList(
      LoadCryptoList event, Emitter<CryptoState> emit) async {
    try {
      // Якщо кеш вже містить дані, повертаємо їх без запиту до API
      if (cryptoListCache.isNotEmpty) {
        emit(CryptoLoaded(
            cryptoListCache)); // Відправляємо стан з кешованими даними
      } else {
        emit(CryptoLoading()); // Відправляємо стан завантаження

        // Виконання HTTP GET запиту до API для отримання списку криптовалют
        final response = await http.get(
          Uri.parse(
              'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true'),
        );

        // Перевірка статусу відповіді
        if (response.statusCode == 200) {
          // Якщо статус успішний (200 OK), декодуємо отриманий JSON
          final data = json.decode(response.body);

          // Зберігаємо отримані дані в кеш
          cryptoListCache = List<Map<String, dynamic>>.from(data);

          // Відправляємо стан з успішно завантаженими даними
          emit(CryptoLoaded(cryptoListCache));
        } else {
          // Якщо виникла помилка при отриманні даних, відправляємо помилку
          emit(CryptoError(errorMessage: 'Failed to load crypto list.'));
        }
      }
    } catch (e) {
      // Ловимо помилки і відправляємо стан помилки з повідомленням
      emit(CryptoError(errorMessage: e.toString()));
    }
  }
}
