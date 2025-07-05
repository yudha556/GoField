import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyBarChart extends StatefulWidget {
  const MyBarChart({super.key});

  @override
  State<MyBarChart> createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 120,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipHorizontalAlignment: FLHorizontalAlignment.right,
            tooltipMargin: -10,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x) {
                case 0:
                  weekDay = 'Senin';
                  break;
                case 1:
                  weekDay = 'Selasa';
                  break;
                case 2:
                  weekDay = 'Rabu';
                  break;
                case 3:
                  weekDay = 'Kamis';
                  break;
                case 4:
                  weekDay = 'Jumat';
                  break;
                case 5:
                  weekDay = 'Sabtu';
                  break;
                case 6:
                  weekDay = 'Minggu';
                  break;
                default:
                  throw Error();
              }
              return BarTooltipItem(
                '$weekDay\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: (rod.toY - 1).toString(),
                    style: TextStyle(
                      color: rod.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getTitles,
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 30,
              getTitlesWidget: leftTitleWidgets,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: showingGroups(),
        gridData: FlGridData(
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
          horizontalInterval: 30,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withOpacity(0.3),
              strokeWidth: 1,
            );
          },
        ),
      ),
      swapAnimationDuration: animDuration,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );
    String text;
    if (value == 0) {
      text = '0';
    } else if (value == 30) {
      text = '30';
    } else if (value == 60) {
      text = '60';
    } else if (value == 90) {
      text = '90';
    } else if (value == 120) {
      text = '120';
    } else {
      return Container();
    }
    return Padding(
    padding: const EdgeInsets.only(top: 8.0),
      child: Text(text, style: style),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.w600,
      fontSize: 10,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Sen', style: style);
        break;
      case 1:
        text = const Text('Sel', style: style);
        break;
      case 2:
        text = const Text('Rab', style: style);
        break;
      case 3:
        text = const Text('Kam', style: style);
        break;
      case 4:
        text = const Text('Jum', style: style);
        break;
      case 5:
        text = const Text('Sab', style: style);
        break;
      case 6:
        text = const Text('Min', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: text,
  );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, 12, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 25, 35, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 100, 80, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 75, 90, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 60, 45, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 40, 55, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 30, 40, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartGroupData makeGroupData(
    int x,
    double y1,
    double y2, {
    bool isTouched = false,
    Color barColor1 = Colors.blueAccent,
    Color barColor2 = Colors.redAccent,
    double width = 16,
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y1 + 1 : y1,
          color: isTouched ? barColor1.withOpacity(0.8) : barColor1,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: barColor1.withOpacity(0.8))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 120,
            color: Colors.grey.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: isTouched ? y2 + 1 : y2,
          color: isTouched ? barColor2.withOpacity(0.8) : barColor2,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: barColor2.withOpacity(0.8))
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 120,
            color: Colors.grey.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
