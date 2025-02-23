import 'package:flutter/material.dart'; // Імпорт бібліотеки для UI Flutter
import 'package:intl/intl.dart'; // Для форматування дат
import 'package:syncfusion_flutter_charts/charts.dart'; // Імпорт бібліотеки для Syncfusion графіків

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
    int dataLength = prices.length > 30 ? 30 : prices.length;

    // Поточна дата
    DateTime now = DateTime.now();

    // Генерація списку дат за останні 30 днів
    List<String> dateLabels = List.generate(dataLength, (index) {
      DateTime date = now.subtract(Duration(days: dataLength - index - 1));
      return DateFormat('dd/MM').format(date); // Форматуємо дату як dd/MM
    });

    // Параметри для інтервалів осі Y
    double maxPrice = prices.reduce((a, b) => a > b ? a : b);
    double minPrice = prices.reduce((a, b) => a < b ? a : b);
    double range = maxPrice - minPrice;

    // Динамічне налаштування інтервалу на осі Y
    double yInterval =
        range / 10; // Ділимо діапазон на 10 для зручного інтервалу

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

              // Перевірка наявності даних для графіка (спарклайн за останні 30 днів)
              if (crypto['sparkline_in_7d'] != null &&
                  crypto['sparkline_in_7d']['price'] != null &&
                  crypto['sparkline_in_7d']['price'].isNotEmpty)
                SizedBox(
                  height: 300.0,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      isVisible: false, // Сховаємо вісь X
                      majorGridLines: MajorGridLines(width: 0),
                    ),
                    primaryYAxis: NumericAxis(
                      isVisible:
                          false, // Сховаємо вісь Y, не будемо показувати ціни
                      minimum: minPrice - (yInterval / 2), // Мінімум для осі Y
                      maximum: maxPrice + (yInterval / 2), // Максимум для осі Y
                      interval: yInterval, // Динамічний інтервал
                      // Центруємо шкалу по середньому значенню
                      desiredIntervals: 5,
                      majorTickLines: MajorTickLines(size: 0),
                    ),
                    series: <CartesianSeries>[
                      LineSeries<ChartData, String>(
                        dataSource: List.generate(
                          dataLength,
                          (index) => ChartData(
                            dateLabels[index], // Мітка для кожної точки
                            prices[index],
                          ),
                        ),
                        xValueMapper: (ChartData data, _) => data.date,
                        yValueMapper: (ChartData data, _) => data.price,
                        color: Colors.green,
                        dataLabelSettings: DataLabelSettings(
                            isVisible: true), // Відображення значень цін
                        markerSettings: MarkerSettings(
                          isVisible: true, // Відображення маркерів (точок)
                          color: Colors.blue, // Колір точок
                          shape: DataMarkerType.circle, // Форма точок
                          borderWidth: 2, // Ширина кордону точки
                          height: 6, // Розмір точок
                          width: 6, // Ширина точок
                        ),
                      ),
                    ],
                    tooltipBehavior: TooltipBehavior(
                      enable: true, // Включаємо тултіп
                      tooltipPosition: TooltipPosition
                          .pointer, // Тултіп буде з'являтись біля курсора
                      header: 'Ціна', // Заголовок тултіпа
                      format:
                          'point.x: {point.y} USD', // Формат виведення (дата: ціна)
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
                    'Немає даних для графіка за останні 30 днів.',
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

// Клас для зберігання даних графіка
class ChartData {
  final String date;
  final double price;

  ChartData(this.date, this.price);
}
