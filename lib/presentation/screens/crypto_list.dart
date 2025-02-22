import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypto_info/bloc/crypto_bloc.dart';
import 'package:crypto_info/presentation/screens/crypto_detaile_page.dart';

class CryptoListPage extends StatelessWidget {
  const CryptoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Tracker')),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CryptoLoaded) {
            return ListView.builder(
              itemCount: state.cryptoList.length,
              itemBuilder: (context, index) {
                final crypto = state.cryptoList[index];
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
          } else {
            return const Center(child: Text('Error loading data'));
          }
        },
      ),
    );
  }
}
