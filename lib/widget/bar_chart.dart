import 'package:expanse_tracker/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';

class WeeklyBarChart extends StatefulWidget {
  const WeeklyBarChart({super.key});

  @override
  State<WeeklyBarChart> createState() => _WeeklyBarChartState();
}

class _WeeklyBarChartState extends State<WeeklyBarChart> {
  final Map<String, double> weeklyExpenses = {
    'Mon': 50.0,
    'Tue': 80.0,
    'Wed': 30.0,
    'Thu': 100.0,
    'Fri': 60.0,
    'Sat': 20.0,
    'Sun': 90.0,
  };

  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;

  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    rawBarGroups = Helper.getStaticByWeek();

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Breakdown'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                alignment: BarChartAlignment.spaceAround,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final days = [
                          'Mon'.tr,
                          'Tue'.tr,
                          'Wed'.tr,
                          'Thu'.tr,
                          'Fri'.tr,
                          'Sat'.tr,
                          'Sun'.tr,
                        ];
                        return Text(
                          days[value.toInt()],
                          style: TextStyle(fontSize: 10),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine:
                      (value) =>
                          FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                  drawVerticalLine: false,
                ),
                barGroups: showingBarGroups,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(fontSize: 10);
    return SideTitleWidget(
      meta: meta,
      child: Text(meta.formattedValue, style: style),
    );
  }
}
