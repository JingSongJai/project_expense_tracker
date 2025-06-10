import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/widget/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  var _data;
  int touchedIndex = -1;
  String selectedText = 'Income';
  double value = 10;
  bool isHover = false;

  final List<String> _dropdownData = ['Expense', 'Income'];

  @override
  void initState() {
    super.initState();
    _updateData();
  }

  void _updateData() {
    _data =
        Helper.getAmountByCategory(selectedText == 'Income' ? false : true).map(
          (data) {
            return PieChartSectionData(
              color: data['color'],
              value:
                  (data['total'] /
                      (selectedText.compareTo('Income') == 0
                          ? Helper.getTotalIncome()
                          : Helper.getTotalExpense())) *
                  360,
              showTitle: true,
              title: data['total'].toString(),
              titleStyle: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.secondary,
              ),
              radius: 60,
            );
          },
        ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          if (!isHover) value += 3;
          isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          if (isHover) value -= 3;
          isHover = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: value - 7,
              color: Colors.grey.shade300,
              offset: Offset(0, value - 7),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Category Distribution',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: DropdownButton<String>(
                    isDense: true,
                    dropdownColor: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(5),
                    value: selectedText,
                    underline: Container(color: Colors.blue),
                    items:
                        _dropdownData
                            .map(
                              (data) => DropdownMenuItem(
                                value: data,
                                child: Text(
                                  data,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedText = value ?? '';
                        _updateData();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (_data.length != 0)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 1,
                          sections: _data,
                          pieTouchData: PieTouchData(
                            touchCallback: (
                              FlTouchEvent event,
                              pieTouchResponse,
                            ) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                final newIndex =
                                    pieTouchResponse
                                        .touchedSection!
                                        .touchedSectionIndex;
                                if (newIndex >= 0 && newIndex < _data.length) {
                                  touchedIndex = newIndex;
                                } else {
                                  touchedIndex = -1;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (Responsive.isWindow(context))
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            Helper.getAmountByCategory(
                                  selectedText == 'Income' ? false : true,
                                )
                                .map(
                                  (data) => Indicator(
                                    color: data['color'],
                                    text: data['category'],
                                    isSquare: false,
                                    size: touchedIndex == 0 ? 12 : 10,
                                    textColor:
                                        touchedIndex == 0
                                            ? Constant.primaryColor
                                            : Color(0xFFA3A3A3),
                                  ),
                                )
                                .toList(),
                      ),
                  ],
                ),
              ),
            if (!Responsive.isWindow(context))
              Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                  Helper.getAmountByCategory(
                    selectedText == 'Income' ? false : true,
                  ).length,
                  (index) {
                    var data =
                        Helper.getAmountByCategory(
                          selectedText == 'Income' ? false : true,
                        )[index];
                    return Indicator(
                      color: data['color'],
                      text: data['category'],
                      isSquare: false,
                      size: touchedIndex == index ? 10 : 8,
                      textColor:
                          touchedIndex == index
                              ? Constant.primaryColor
                              : Color(0xFFA3A3A3),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
