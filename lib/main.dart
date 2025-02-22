import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Bloc Events
abstract class CryptoEvent {}

class LoadCryptoList extends CryptoEvent {}

class LoadCryptoDetails extends CryptoEvent {
  final String id;
  LoadCryptoDetails(this.id);
}

// Bloc State
abstract class CryptoState {}

class CryptoLoading extends CryptoState {}

class CryptoLoaded extends CryptoState {
  final List<dynamic> cryptoList;
  CryptoLoaded(this.cryptoList);
}

class CryptoDetailsLoaded extends CryptoState {
  final Map<String, dynamic> cryptoDetails;
  CryptoDetailsLoaded(this.cryptoDetails);
}

class CryptoError extends CryptoState {}

// Bloc
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  CryptoBloc() : super(CryptoLoading()) {
    on<LoadCryptoList>(_loadCryptoList);
    on<LoadCryptoDetails>(_loadCryptoDetails);
  }

  Future<void> _loadCryptoList(
      LoadCryptoList event, Emitter<CryptoState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true'),
      );
      final data = json.decode(response.body);
      emit(CryptoLoaded(data));
    } catch (_) {
      emit(CryptoError());
    }
  }

  Future<void> _loadCryptoDetails(
      LoadCryptoDetails event, Emitter<CryptoState> emit) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.coingecko.com/api/v3/coins/${event.id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true'),
      );
      final data = json.decode(response.body);
      emit(CryptoDetailsLoaded(data));
    } catch (_) {
      emit(CryptoError());
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBloc()..add(LoadCryptoList()),
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: CryptoListPage(),
      ),
    );
  }
}

// Головна сторінка
class CryptoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crypto Tracker')),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (context, state) {
          if (state is CryptoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CryptoLoaded) {
            return ListView.builder(
              itemCount: state.cryptoList.length,
              itemBuilder: (context, index) {
                final crypto = state.cryptoList[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(crypto['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ціна: \$${crypto['current_price']}'),
                        SizedBox(height: 8),
                        Text('Графік за 7 днів'),
                        SizedBox(height: 8),
                        if (crypto['sparkline_in_7d'] != null &&
                            crypto['sparkline_in_7d']['price'] != null)
                          SizedBox(
                            height: 100,
                            child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    spots: List.generate(
                                      crypto['sparkline_in_7d']['price'].length,
                                      (index) => FlSpot(
                                        index.toDouble(),
                                        crypto['sparkline_in_7d']['price']
                                                [index]
                                            .toDouble(),
                                      ),
                                    ),
                                    isCurved: true,
                                    color: Colors.blue,
                                    barWidth: 2,
                                  )
                                ],
                                titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      getTitlesWidget:
                                          (double value, TitleMeta meta) {
                                        int index = value.toInt();
                                        if (index % 24 == 0) {
                                          return Text('${7 - (index ~/ 24)} д.',
                                              style: TextStyle(fontSize: 10));
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                ),
                                gridData: FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                              ),
                            ),
                          ),
                      ],
                    ),
                    leading: Image.network(crypto['image']),
                    onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           CryptoDetailPage(id: crypto['id']),
                      //     ),
                      //   );
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Error loading data'));
          }
        },
      ),
    );
  }
} // Детальна сторінка криптовалюти
