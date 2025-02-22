import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CryptoDetailPage extends StatelessWidget {
  final Map<String, dynamic> crypto;

  const CryptoDetailPage({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(crypto['name'])),
      body: Column(
        children: [
          Hero(
            tag: 'crypto-${crypto['id']}',
            child: Image.network(crypto['image']),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Ціна: \$${crypto['current_price']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          // Check if the sparkline data exists
          if (crypto['sparkline_in_7d'] != null &&
              crypto['sparkline_in_7d']['price'] != null &&
              crypto['sparkline_in_7d']['price'].isNotEmpty)
            SizedBox(
              height: 300.0, // Adjust the height of the chart
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        crypto['sparkline_in_7d']['price'].length,
                        (index) => FlSpot(
                          index.toDouble(),
                          crypto['sparkline_in_7d']['price'][index].toDouble(),
                        ),
                      ),
                      color: Colors.green, // Set the color of the line
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (double value, TitleMeta meta) {
                          int index = value.toInt();
                          if (index % 24 == 0) {
                            return Text('${index / 24} д.');
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    drawHorizontalLine: false,
                    verticalInterval: 5,
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
