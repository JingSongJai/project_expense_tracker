import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

ValueNotifier<int> selectedIndex = ValueNotifier(0);
late ValueNotifier<List<ExpenseModel>> expenses;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  expenses = ValueNotifier(expenseBox.values.toList() as List<ExpenseModel>);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
