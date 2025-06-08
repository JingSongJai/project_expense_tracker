import 'dart:developer';
import 'dart:io';

import 'package:expanse_tracker/controller/notification_controller.dart';
import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/model/category_model.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/model/recure_model.dart';
import 'package:expanse_tracker/translation/translation.dart';
import 'package:expanse_tracker/view/main_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:timezone/data/latest.dart' as tz;

ValueNotifier<int> selectedIndex = ValueNotifier(0);
late ValueNotifier<List<ExpenseModel>> expenses;
late ValueNotifier<List<CategoryModel>> categories;
late ValueNotifier<List<RecureModel>> recures;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  if (!kIsWeb) {
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      windowManager.setPreventClose(true);
    }
  }

  //Init Notification
  await NotificationController.initNotification();
  await NotificationController.requestPermission();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  await Hive.initFlutter();

  //Register Adapters
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(RecureModelAdapter());

  //Open Boxes
  expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  categoryBox = await Hive.openBox<CategoryModel>('categories');
  recureBox = await Hive.openBox<RecureModel>('recures');

  if (prefs.getBool('isFirstTime') == null) {
    categoryBox.addAll(
      Constant.expenseCategories
          .map((data) => CategoryModel.fromJson(data))
          .toList(),
    );
  }

  //Assign value to ValueNotifier variables
  expenses = ValueNotifier(expenseBox.values.toList() as List<ExpenseModel>);
  categories = ValueNotifier(
    categoryBox.values.toList() as List<CategoryModel>,
  );
  recures = ValueNotifier(recureBox.values.toList() as List<RecureModel>);

  //Check whether is first time ever
  if (prefs.getBool('isFirstTime') == null) {
    await prefs.setBool('isFirstTime', true);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String name = 'Expense Tracker';

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: name,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Kantumruy',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.accentColor,
            elevation: 0,
            textStyle: TextStyle(color: Colors.white, fontFamily: 'Kantumruy'),
          ),
        ),
        useMaterial3: true,
      ),
      home: MainScreen(),
      translations: AppTranslation(),
      locale: Locale('en'),
      fallbackLocale: Locale('en'),
    );
  }
}
