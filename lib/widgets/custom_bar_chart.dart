import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:noted/core/app_colors.dart';
import 'package:noted/core/formatter.dart';

class CustomBarChart extends StatelessWidget {
  final BuildContext context;
  final List<int> daysData;
  final int totalHabitLength;
  final DateTime startDate;
  final DateTime endDate;
  const CustomBarChart(
      {super.key,
      required this.context,
      required this.daysData,
      required this.totalHabitLength,
      required this.startDate,
      required this.endDate});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: totalHabitLength.toDouble(),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text = "";
    Map<int, String> dayMap = {};
    List<String> daysList = TFormatter.divideDateRange(startDate, endDate);

    if (endDate.difference(startDate).inDays == 6) {
      List<String> getListOfWeeks =
          TFormatter.getDaysOfWeek(startDate, endDate);
      if (value.toInt() >= 0 && value.toInt() < daysList.length) {
        text = getListOfWeeks[value.toInt()].toString();
      } else {
        text = '';
      }
    } else {
      if (value.toInt() >= 0 && value.toInt() < daysList.length) {
        text = daysList[value.toInt()].toString();
      } else {
        text = '';
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 24,
            getTitlesWidget: (value, meta) {
              return value % 1 == 0
                  ? Text(value.toStringAsFixed(0))
                  : Container();
            },
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  List<BarChartGroupData> get barGroups {
    List<int> data = TFormatter.divideListIntoParts(daysData);

    return List.generate(
        data.length,
        (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                    toY: data[index].toDouble(), color: TColors.appPrimaryColor)
              ],
              showingTooltipIndicators: [],
            ));
  }
}
