import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/widget/bar_chart.dart';
import 'package:expanse_tracker/widget/pie_chart.dart';
import 'package:expanse_tracker/widget/static_widget.dart';
import 'package:expanse_tracker/widget/transaction_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatis(),

          const SizedBox(height: 20),

          SizedBox(height: 300, child: _buildGraph()),

          const SizedBox(height: 20),

          if (Responsive.isMobile(context))
            SizedBox(height: 300, child: PieChartWidget()),

          if (Responsive.isMobile(context)) const SizedBox(height: 20),

          _buildItems(),
        ],
      ),
    );
  }

  Widget _buildStatis() {
    return Row(
      children: [
        Expanded(
          child: StatisWidget(
            title: 'Expense',
            number: '\$ ${Helper.getTotalExpense()}',
            firstColor: Color(0xFFffbe96),
            secondColor: Color(0xFFfe8696),
            icon: Icons.money_off_rounded,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: StatisWidget(
            title: 'Income',
            number: '\$ ${Helper.getTotalIncome()}',
            firstColor: Color(0xFF8cc8f8),
            secondColor: Color(0xFF2992e6),
            icon: Icons.attach_money_rounded,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: StatisWidget(
            title: 'Total',
            number: '\$ ${Helper.getTotal()}',
            firstColor: Color(0xFF82d9d1),
            secondColor: Color(0xFF29d0b8),
            icon: Icons.monetization_on,
          ),
        ),
      ],
    );
  }

  Widget _buildGraph() {
    return Row(
      children: [
        Expanded(child: WeeklyBarChart()),
        if (!Responsive.isMobile(context)) const SizedBox(width: 20),
        if (!Responsive.isMobile(context)) Expanded(child: PieChartWidget()),
      ],
    );
  }

  Widget _buildItems() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder(
            valueListenable: expenses,
            builder: (context, value, child) {
              return Column(
                children: List.generate(expenses.value.length, (index) {
                  return TransactionItem(
                    expense: expenseBox.getAt(index),
                    index: index,
                    isEdited: false,
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
