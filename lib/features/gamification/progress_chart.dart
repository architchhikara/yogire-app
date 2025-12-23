import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressChart extends StatelessWidget {
  final List<double> history; // 7 days history, 0.0 to 1.0

  const ProgressChart({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.0,
          barTouchData: const BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );

                  int daysAgo = 6 - value.toInt();
                  String text;
                  if (daysAgo == 0) {
                    text = 'Today';
                  } else if (daysAgo == 1) {
                    text = 'Yest';
                  } else {
                    text = '-${daysAgo}d';
                  }

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(text, style: style),
                  );
                },
                reservedSize: 20,
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(history.length, (index) {
            if (index >= 7) return null; // Safety

            int visualIndex = 6 - index;
            double val = history[index];

            return BarChartGroupData(
              x: visualIndex,
              barRods: [
                BarChartRodData(
                  toY: val,
                  color: Colors.orange,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 1.0,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            );
          }).whereType<BarChartGroupData>().toList(),
        ),
      ),
    );
  }
}
