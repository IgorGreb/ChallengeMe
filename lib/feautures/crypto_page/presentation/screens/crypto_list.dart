import 'package:crypto_info/core/colors.dart'; // Імпортуємо користувацькі кольори
import 'package:flutter/material.dart'; // Імпортуємо основні віджети Flutter
import 'package:flutter_bloc/flutter_bloc.dart'; // Імпортуємо BLoC для керування станами
import 'package:crypto_info/feautures/crypto_page/bloc/crypto_bloc.dart'; // Імпортуємо блок для криптовалют
import 'package:crypto_info/feautures/crypto_detaile_page/presentation/screens/crypto_detaile_page.dart'; // Імпортуємо сторінку з деталями криптовалюти
import 'package:shimmer/shimmer.dart'; // Імпортуємо пакет для шиммер-ефекту

// Створюємо StatefulWidget для сторінки зі списком криптовалют
class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key}); // Конструктор для CryptoListPage

  @override
  CryptoListPageState createState() =>
      CryptoListPageState(); // Створюємо стан для цього виджета
}

// Стан сторінки зі списком криптовалют
class CryptoListPageState extends State<CryptoListPage> {
  final TextEditingController _searchController =
      TextEditingController(); // Контролер для пошукового поля
  List<dynamic> _filteredCryptoList = []; // Список відфільтрованих криптовалют
  List<dynamic> _allCryptoList = []; // Список всіх криптовалют
  final FocusNode _focusNodeSearchField =
      FocusNode(); // Фокус для пошукового поля

  @override
  void dispose() {
    // Звільняємо фокус і інші ресурси при закритті сторінки
    _focusNodeSearchField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Будуємо основний UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'), // Заголовок сторінки
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), // Висота панелі пошуку
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: _focusNodeSearchField, // Фокус для поля
              controller: _searchController, // Контролер для тексту в полі
              cursorColor: CustomColors.white, // Колір курсору
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: CustomColors.white, // Колір іконки пошуку
                ),
                enabledBorder: OutlineInputBorder(
                  // Стиль для непотрібного фокусу
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: CustomColors
                        .grey, // Колір бордера для непотрібного фокусу
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  // Стиль для фокусу
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: CustomColors
                        .primaryColor, // Колір бордера під час фокусу
                    width: 2.0,
                  ),
                ),
                hintText: 'Пошук...', // Текст підказки
                hintStyle:
                    TextStyle(color: CustomColors.white), // Стиль підказки
              ),
              onChanged: (query) {
                // Викликається при зміні тексту в полі
                _filterCryptoList(query);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        // Використовуємо BlocBuilder для слухання станів
        builder: (context, state) {
          if (state is CryptoLoading) {
            // Якщо криптовалюти завантажуються, показуємо ефект шиммера
            return ListView.builder(
              itemCount: 10, // Імітуємо 10 елементів для завантаження
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white, // Шиммер для заголовка
                      ),
                      subtitle: Container(
                        width: 150,
                        height: 15,
                        color: Colors.white, // Шиммер для підпису
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white, // Шиммер для іконки
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is CryptoLoaded) {
            // Якщо криптовалюти завантажено, збережемо їх для пошуку
            if (_allCryptoList.isEmpty) {
              _allCryptoList = state.cryptoList;
              _filteredCryptoList = state.cryptoList;
            }

            // Якщо відфільтрований список порожній
            if (_filteredCryptoList.isEmpty) {
              return const Center(
                child:
                    Text('Нічого не знайдено', style: TextStyle(fontSize: 18)),
              );
            }

            // Відображення списку криптовалют
            return ListView.builder(
              itemCount:
                  _filteredCryptoList.length, // Кількість елементів у списку
              itemBuilder: (context, index) {
                final crypto = _filteredCryptoList[
                    index]; // Криптовалюта для поточного елементу
                return Card(
                  color: Colors.white, // Колір картки
                  margin: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    // Перехід на сторінку з деталями криптовалюти при натисканні
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CryptoDetailPage(crypto: crypto),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        crypto['name'], // Назва криптовалюти
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black, // Колір тексту
                        ),
                      ),
                      subtitle: Text(
                        'Ціна: \$${crypto['current_price']}', // Ціна криптовалюти
                        style: const TextStyle(
                          color: Colors.green, // Зелений колір для ціни
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      leading: ClipOval(
                        // Відображення іконки криптовалюти
                        child: Image.network(
                          crypto['image'], // URL іконки
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is CryptoError) {
            // Якщо сталася помилка при завантаженні даних
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red, // Іконка помилки
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Помилка при завантаженні даних', // Повідомлення про помилку
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white, // Білий колір для тексту
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('Невідомий стан')); // Якщо стан невідомий
          }
        },
      ),
    );
  }

  // Функція для фільтрації криптовалют по пошуковому запиту
  void _filterCryptoList(String query) {
    final filteredList = query.isEmpty
        ? _allCryptoList // Якщо запит порожній, показуємо всі криптовалюти
        : _allCryptoList
            .where((crypto) => crypto['name']
                .toLowerCase()
                .contains(query.toLowerCase())) // Фільтрація по назві
            .toList();

    setState(() {
      _filteredCryptoList = filteredList; // Оновлюємо відфільтрований список
    });
  }
}
