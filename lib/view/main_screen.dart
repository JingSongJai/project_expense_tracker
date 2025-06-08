import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/view/budgets_screen.dart';
import 'package:expanse_tracker/view/category_screen.dart';
import 'package:expanse_tracker/view/home_screen.dart';
import 'package:expanse_tracker/view/recurring_screen.dart';
import 'package:expanse_tracker/view/transaction_screen.dart';
import 'package:expanse_tracker/widget/alert_widget.dart';
import 'package:expanse_tracker/widget/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant.backgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            if (Responsive.isWindow(context) || Responsive.isTablet(context))
              buildSideBarMenu(),
            Expanded(child: buildBody()),
          ],
        ),
      ),
      bottomNavigationBar:
          Responsive.isMobile(context) ? buildBottomMenu() : null,
      endDrawer: _buildEndDrawer(),
    );
  }

  Widget buildSideBarMenu() {
    return SideBarWidget();
  }

  Widget buildBottomMenu() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(Constant.menus.length, (index) {
          return _buildMenuItem(
            index,
            Constant.menus[index]['icon']!,
            Constant.menus[index]['title']!,
          );
        }),
      ),
    );
  }

  Widget _buildMenuItem(int index, String path, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex.value = index;
        });
      },
      borderRadius: BorderRadius.circular(100),
      child: Tooltip(
        message: title,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            path,
            colorFilter: ColorFilter.mode(
              selectedIndex.value == index
                  ? Constant.primaryColor
                  : Color(0xFF696969),
              BlendMode.srcIn,
            ),
            width: 22,
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      color: Constant.backgroundColor,
      child: Column(
        children: [_buildTopBar(), Expanded(child: _buildPageDisplay())],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 80,
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(width: 20),
          if (Responsive.isMobile(context))
            CircleAvatar(
              backgroundImage: AssetImage('assets/png/App Icon.png'),
            ),
          if (Responsive.isWindow(context) || Responsive.isTablet(context))
            IconButton(
              icon: SvgPicture.asset(
                'assets/svg/Menu Icon.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xffa3a3a3),
                  BlendMode.srcIn,
                ),
              ),
              onPressed:
                  () => setState(() {
                    Constant.isExtended = !Constant.isExtended;
                  }),
            ),
          // if (Responsive.isWindow(context) || Responsive.isTablet(context))
          //   Expanded(
          //     child: TextField(
          //       style: TextStyle(fontSize: 13),
          //       decoration: InputDecoration(
          //         border: OutlineInputBorder(borderSide: BorderSide.none),
          //         hintText: 'Search',
          //         hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
          //         prefixIcon: Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: SvgPicture.asset(
          //             'assets/svg/Search Icon.svg',
          //             colorFilter: ColorFilter.mode(
          //               Color(0xFFA3A3A3),
          //               BlendMode.srcIn,
          //             ),
          //             width: 20,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // const Spacer(),
          // if (Responsive.isMobile(context))
          //   SvgPicture.asset(
          //     'assets/svg/Search Icon.svg',
          //     colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
          //   ),
          // if (Responsive.isMobile(context)) const SizedBox(width: 10),
          // Builder(
          //   builder: (context) {
          //     return GestureDetector(
          //       onTap: () async {
          //         Get.updateLocale(
          //           Get.locale == Locale('en') ? Locale('km') : Locale('en'),
          //         );
          //         Get.changeTheme(
          //           Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
          //         );
          //       },
          //       child: ValueListenableBuilder(
          //         valueListenable: Helper.alerts,
          //         builder:
          //             (context, value, child) => Badge.count(
          //               count: value.length,
          //               child: SvgPicture.asset(
          //                 'assets/svg/Notification Icon.svg',
          //                 colorFilter: ColorFilter.mode(
          //                   Colors.grey.shade400,
          //                   BlendMode.srcIn,
          //                 ),
          //               ),
          //             ),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildEndDrawer() {
    Helper.getNotification();

    return Drawer(
      backgroundColor: Constant.backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Notification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Helper.alerts,
              builder:
                  (context, value, child) => ListView.builder(
                    itemCount: value.length,
                    itemBuilder:
                        (context, index) => AlertWidget(category: value[index]),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageDisplay() {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder:
          (context, value, child) => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _getDisplayPage(value),
          ),
    );
  }

  Widget _getDisplayPage(int index) {
    Widget? widget;

    switch (index) {
      case 0:
        widget = HomeScreen();
        break;

      case 1:
        widget = TransactionScreen();
        break;

      case 2:
        widget = CategoryScreen();
        break;

      case 3:
        widget = BudgetsScreen();
        break;

      case 4:
        widget = RecurringPaymentScreen();
        break;

      case 5:
      case 6:
      case 7:
        widget = HomeScreen();
        break;
    }

    return widget!;
  }
}
