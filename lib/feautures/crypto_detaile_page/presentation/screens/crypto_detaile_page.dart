import 'dart:math';
import 'package:fl_chart/fl_chart.dart'; // Імпорт бібліотеки для побудови графіків
import 'package:flutter/material.dart'; // Імпорт бібліотеки для UI Flutter
import 'package:intl/intl.dart'; // Для форматування дат

// Клас сторінки деталей криптовалюти, що приймає дані про криптовалюту як параметр
class CryptoDetailPage extends StatelessWidget {
  final Map<String, dynamic>
      crypto; // Криптовалюта, яку будемо відображати на сторінці

  // Конструктор для ініціалізації сторінки з переданим об'єктом криптовалюти
  const CryptoDetailPage({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    // Отримуємо список цін з API
    List<double> prices = List<double>.from(crypto['sparkline_in_7d']['price']
        .map((e) => e.toDouble())); // Перевіряємо, що тут є тільки числа

    // Перевірка на кількість точок для графіка (щоб уникнути помилки)
    int dataLength = prices.length > 7 ? 7 : prices.length;

    // Поточна дата
    DateTime now = DateTime.now();

    // Генерація списку дат за останні 7 днів
    List<String> dateLabels = List.generate(dataLength, (index) {
      DateTime date = now.subtract(Duration(days: dataLength - index - 1));
      return DateFormat('dd/MM').format(date); // Форматуємо дату як dd/MM
    });

    return Scaffold(
      appBar: AppBar(
        title:
            Text(crypto['name']), // Заголовок для AppBar з назвою криптовалюти
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Відступи для зручності
          child: Column(
            children: [
              // Герой-ефект для зображення криптовалюти
              Hero(
                tag: 'crypto-${crypto['id']}',
                child: Image.network(
                  crypto['image'], // URL зображення криптовалюти
                  height: 200,
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

              // Перевірка наявності даних для графіка (спарклайн за останні 7 днів)
              if (crypto['sparkline_in_7d'] != null &&
                  crypto['sparkline_in_7d']['price'] != null &&
                  crypto['sparkline_in_7d']['price'].isNotEmpty)
                SizedBox(
                  height: 300.0,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            dataLength,
                            (index) => FlSpot(
                              (index + 1).toDouble(), // Починаємо з 1
                              prices[index],
                            ),
                          ),
                          color: Colors.green.withValues(alpha: 0.7),
                          belowBarData: BarAreaData(
                            show: true,
                            color: Colors.green.withOpacity(0.1),
                          ),
                          dotData: FlDotData(show: true),
                          barWidth: 1,
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            reservedSize: 50,
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              // Відображення дат на осі X
                              int index = value.toInt() -
                                  1; // Оскільки ми починаємо з 1
                              if (index >= 0 && index < dateLabels.length) {
                                String date = dateLabels[index];
                                return RotatedBox(
                                  quarterTurns: 1,
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          axisNameSize: 1,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: false,
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              // Якщо дані для графіка відсутні
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
