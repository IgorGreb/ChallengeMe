import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_info/bloc/crypto_bloc.dart';
import 'package:crypto_info/presentation/screens/crypto_detaile_page.dart';
import 'package:shimmer/shimmer.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredCryptoList = [];
  List<dynamic> _allCryptoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Tracker'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Пошук криптовалюти',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (query) {
                _filterCryptoList(query);
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            // Шиммер-ефект під час завантаження
            return ListView.builder(
              itemCount: 10, // Імітація 10 елементів для завантаження
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
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        width: 150,
                        height: 15,
                        color: Colors.white,
                      ),
                      leading: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is CryptoLoaded) {
            // Збережемо всі криптовалюти в список для пошуку
            if (_allCryptoList.isEmpty) {
              _allCryptoList = state.cryptoList;
              _filteredCryptoList = state.cryptoList;
            }

            // Показуємо відфільтрований список
            return ListView.builder(
              itemCount: _filteredCryptoList.length,
              itemBuilder: (context, index) {
                final crypto = _filteredCryptoList[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: GestureDetector(
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
                      title: Text(crypto['name']),
                      subtitle: Text(
                        'Ціна: \$${crypto['current_price']}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      leading: Image.network(crypto['image']),
                    ),
                  ),
                );
              },
            );
          } else if (state is CryptoError) {
            // Обробка помилки
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text('Помилка при завантаженні даних'),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Невідомий стан'));
          }
        },
      ),
    );
  }

  void _filterCryptoList(String query) {
    final filteredList = _allCryptoList
        .where((crypto) =>
            crypto['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredCryptoList = filteredList;
    });
  }
}
