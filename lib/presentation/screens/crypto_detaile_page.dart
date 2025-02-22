import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CryptoDetailPage extends StatelessWidget {
  final Map<String, dynamic> crypto;

  const CryptoDetailPage({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(crypto['name'])),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Hero(
                tag: 'crypto-${crypto['id']}',
                child: Image.network(
                  crypto['image'],
                  height: 200, // Задаємо висоту зображення для кращого вигляду
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ціна: \$${crypto['current_price']}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Перевірка наявності даних для графіка
              if (crypto['sparkline_in_7d'] != null &&
                  crypto['sparkline_in_7d']['price'] != null &&
                  crypto['sparkline_in_7d']['price'].isNotEmpty)
                SizedBox(
                  height: 300.0, // Висота графіка
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            crypto['sparkline_in_7d']['price'].length,
                            (index) => FlSpot(
                              index.toDouble(),
                              crypto['sparkline_in_7d']['price'][index]
                                  .toDouble(),
                            ),
                          ),
                          color: Colors.green.withOpacity(
                              0.9), // Колір лінії графіка з прозорістю
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green
                                .withOpacity(0.1), // Прозора зона під графіком
                          ),
                          dotData: FlDotData(
                            show: true, // Включаємо показ точок на графіку
                            // Колір точок
                          ),
                          barWidth: 1, // Товщина лінії
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: false), // Прибираємо цифри на осі X
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles:
                                  false), // Прибираємо цифри на верхній осі X
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles:
                                  false), // Прибираємо всі цифри на осі Y
                        ),
                      ),
                      gridData: FlGridData(
                        show: false, // Прибираємо сітку
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.001), // Колір межі
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              // Якщо дані відсутні
              if (crypto['sparkline_in_7d'] == null ||
                  crypto['sparkline_in_7d']['price'] == null ||
                  crypto['sparkline_in_7d']['price'].isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Немає даних для графіка за останні 7 днів.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
