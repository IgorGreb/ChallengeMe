import 'package:fl_chart/fl_chart.dart'; // Імпорт бібліотеки для побудови графіків
import 'package:flutter/material.dart'; // Імпорт бібліотеки для UI Flutter

// Клас сторінки деталей криптовалюти, що приймає дані про криптовалюту як параметр
class CryptoDetailPage extends StatelessWidget {
  final Map<String, dynamic>
      crypto; // Криптовалюта, яку будемо відображати на сторінці

  // Конструктор для ініціалізації сторінки з переданим об'єктом криптовалюти
  const CryptoDetailPage({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(crypto['name']), // Заголовок для AppBar з назвою криптовалюти
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(
              16.0), // Відступи для зручності розташування елементів
          child: Column(
            children: [
              // Герой-ефект для зображення криптовалюти, щоб анімація була плавною при переході
              Hero(
                tag:
                    'crypto-${crypto['id']}', // Унікальний тег для ефекту героя
                child: Image.network(
                  crypto['image'], // URL зображення криптовалюти
                  height: 200, // Задаємо висоту зображення для кращого вигляду
                  fit: BoxFit.contain, // Підганяємо зображення по контейнеру
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Ціна: \$${crypto['current_price']}', // Відображення поточної ціни криптовалюти
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Стиль для тексту ціни
                  ),
                ),
              ),
              SizedBox(height: 8), // Між елементами

              // Перевірка наявності даних для графіка (спарклайн за останні 7 днів)
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
                            crypto['sparkline_in_7d']['price']
                                .length, // Генерація точок для графіка
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
                          ),
                          barWidth: 1, // Товщина лінії графіка
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
                          color: Colors.grey
                              .withOpacity(0.001), // Колір межі графіка
                          width: 1, // Товщина межі
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
                    'Немає даних для графіка за останні 7 днів.', // Повідомлення, якщо дані відсутні
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
