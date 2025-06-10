import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/view/budgets_screen.dart';
import 'package:expanse_tracker/view/category_screen.dart';
import 'package:expanse_tracker/view/home_screen.dart';
import 'package:expanse_tracker/view/recurring_screen.dart';
import 'package:expanse_tracker/view/settings_screen.dart';
import 'package:expanse_tracker/view/transaction_screen.dart';
import 'package:expanse_tracker/widget/alert_widget.dart';
import 'package:expanse_tracker/widget/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isDarkMode = false;
  String selectedLanguage = 'ENG';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
          Responsive.isMobile(context)
              ? BottomAppBar(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: buildBottomMenu(),
              )
              : null,
      endDrawer: _buildEndDrawer(),
    );
  }

  Widget buildSideBarMenu() {
    return SideBarWidget();
  }

  Widget buildBottomMenu() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [_buildTopBar(), Expanded(child: _buildPageDisplay())],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 80,
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        children: [
          const SizedBox(width: 10),
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
          const Spacer(),
          DropdownButton<String>(
            value: selectedLanguage,
            items: [
              DropdownMenuItem(
                value: 'ENG',
                child: Text('ENG', style: TextStyle(fontSize: 12)),
              ),
              DropdownMenuItem(
                value: 'KM',
                child: Text('KM', style: TextStyle(fontSize: 12)),
              ),
            ],
            onChanged: (value) {
              if (value! == 'ENG') {
                Get.updateLocale(Locale('en'));
              } else {
                Get.updateLocale(Locale('km'));
              }

              setState(() {
                selectedLanguage = value;
              });
            },
            underline: Container(),
            dropdownColor: Theme.of(context).colorScheme.secondary,
            isDense: true,
            icon: Icon(Icons.arrow_drop_down, size: 20),
          ),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () {
              final prefs = Get.find<SharedPreferences>();
              isDarkMode = prefs.getBool('isDarkMode')!;

              if (prefs.getBool('isDarkMode')!) {
                Get.changeThemeMode(ThemeMode.light);
                prefs.setBool('isDarkMode', false);
                setState(() {
                  isDarkMode = false;
                });
              } else {
                Get.changeThemeMode(ThemeMode.dark);
                prefs.setBool('isDarkMode', true);
                setState(() {
                  isDarkMode = true;
                });
              }
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1000),
              reverseDuration: const Duration(milliseconds: 1000),
              child:
                  isDarkMode
                      ? Image.asset(
                        'assets/png/moon-fill.png',
                        color: Theme.of(context).colorScheme.primary,
                        width: 25,
                      )
                      : Image.asset(
                        'assets/png/sun-fill.png',
                        color: Theme.of(context).colorScheme.primary,
                        width: 25,
                      ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildEndDrawer() {
    Helper.getNotification();

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
        widget = SettingsScreen();
        break;
    }

    return widget!;
  }
}
