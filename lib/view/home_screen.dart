import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/widget/bar_chart.dart';
import 'package:expanse_tracker/widget/pie_chart.dart';
import 'package:expanse_tracker/widget/static_widget.dart';
import 'package:expanse_tracker/widget/transaction_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WindowListener, TrayListener {
  double value = 10;
  bool isHover = false;

  @override
  void initState() {
    if (!kIsWeb) if (Platform.isWindows) trayManager.addListener(this);
    super.initState();
    if (!kIsWeb) {
      if (Platform.isWindows) {
        _initTrayIcon();
        windowManager.addListener(this);
      }
    }
  }

  @override
  void onWindowClose() async {
    windowManager.hide();
    super.onWindowClose();
  }

  Future<void> _initTrayIcon() async {
    await trayManager.setIcon('assets/ico/app_icon.ico');
    await trayManager.setToolTip('Expense Tracker');
    await trayManager.setContextMenu(
      Menu(
        items: [
          MenuItem(label: 'Show App', onClick: _onShowApp),
          MenuItem(label: 'Exit', onClick: _onExit),
        ],
      ),
    );
  }

  void _onShowApp(MenuItem item) {
    windowManager.show();
    windowManager.focus();
  }

  void _onExit(MenuItem item) {
    trayManager.destroy();
    windowManager.destroy();
  }

  @override
  void onTrayIconMouseDown() {
    super.onTrayIconMouseDown();
    trayManager.popUpContextMenu();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20),
                _buildStatis(),

                const SizedBox(height: 20),

                if (Responsive.isMobile(context)) const SizedBox(height: 10),

                if (Responsive.isMobile(context))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Graph',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                if (Responsive.isMobile(context))
                  CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                    ),
                    items: [WeeklyBarChart(), PieChartWidget()],
                  ),

                if (!Responsive.isMobile(context))
                  SizedBox(height: 300, child: _buildGraph()),

                const SizedBox(height: 20),

                _buildItems(),
              ],
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildStatis() {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !Responsive.isMobile(context) ? 4 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 150,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        StatisWidget(
          title: 'Expense',
          number: '\$ ${Helper.getTotalExpense()}',
          firstColor: Color(0xFFFF6A88), // Coral Red
          secondColor: Color(0xFFFF9A8B), // Soft Pink
          icon: Icons.money_off_rounded,
        ),
        StatisWidget(
          title: 'Income',
          number: '\$ ${Helper.getTotalIncome()}',
          firstColor: Color(0xFF43C6AC), // Aqua Green
          secondColor: Color(0xFF191654), // Deep Blue
          icon: Icons.attach_money_rounded,
        ),
        StatisWidget(
          title: 'Total',
          number: '\$ ${Helper.getTotal()}',
          firstColor: Color(0xFF8E2DE2), // Royal Purple
          secondColor: Color(0xFF4A00E0), // Electric Indigo
          icon: Icons.monetization_on,
        ),
        StatisWidget(
          title: 'Category',
          number: '\$ ${Helper.getTotal()}',
          firstColor: Color(0xFFFBD786), // Soft Gold
          secondColor: Color(0xFFF7797D), // Warm Sunset
          icon: Icons.category,
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
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
            Text(
              'Recent Transactions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder(
              valueListenable: expenses,
              builder: (context, value, child) {
                if (value.isNotEmpty) {
                  return Column(
                    children: List.generate(expenses.value.length, (index) {
                      return TransactionItem(
                        expense: expenseBox.getAt(index),
                        index: index,
                        isEdited: false,
                      );
                    }),
                  );
                } else {
                  return Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        LottieBuilder.asset(
                          'assets/json/Empty Icon.json',
                          fit: BoxFit.fill,
                          width: 200,
                        ),
                        Text('No recent transactions'),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
