import 'package:flutter/material.dart';

class Constant {
  Constant._();

  static const Color primaryColor = Color(0xFF742BDE);
  static const Color accentColor = Color(0xFFFF633B);
  static const Color backgroundColor = Color(0xFFF5F6FA);

  static var menus = [
    {'title': 'Home', 'icon': 'assets/svg/Home Icon.svg'},
    {'title': 'Transaction', 'icon': 'assets/svg/Transaction Icon.svg'},
    {'title': 'Category', 'icon': 'assets/svg/Category Icon.svg'},
    {'title': 'Budgets', 'icon': 'assets/svg/Budgets Icon.svg'},
    {
      'title': 'Recurring Payment',
      'icon': 'assets/svg/Recurring Payment Icon.svg',
    },
    {'title': 'Settings', 'icon': 'assets/svg/Setting Icon.svg'},
  ];

  static int selectedIndex = 0;
  static bool isExtended = true;

  static final List<Map<String, dynamic>> expenseCategories = [
    {
      'name': 'Groceries',
      'icon': Icons.local_grocery_store,
      'color': Colors.green,
    },
    {'name': 'Utilities', 'icon': Icons.lightbulb, 'color': Colors.blue},
    {
      'name': 'Transportation',
      'icon': Icons.directions_car,
      'color': Colors.orange,
    },
    {'name': 'Insurance', 'icon': Icons.health_and_safety, 'color': Colors.red},
    {'name': 'Restaurants', 'icon': Icons.restaurant, 'color': Colors.purple},
    {'name': 'Medical', 'icon': Icons.local_hospital, 'color': Colors.teal},
    {'name': 'Clothing', 'icon': Icons.checkroom, 'color': Colors.pink},
    {'name': 'Entertainment', 'icon': Icons.movie, 'color': Colors.amber},
    {'name': 'Education', 'icon': Icons.school, 'color': Colors.indigo},
    {'name': 'Personal Care', 'icon': Icons.face, 'color': Colors.cyan},
    {
      'name': 'Subscriptions',
      'icon': Icons.subscriptions,
      'color': Colors.lime,
    },
    {
      'name': 'Games',
      'icon': Icons.videogame_asset,
      'color': Colors.deepPurple,
    },
    {
      'name': 'Vacations / Travel',
      'icon': Icons.airplanemode_active,
      'color': Colors.lightBlue,
    },
    {'name': 'Drink', 'icon': Icons.local_bar, 'color': Colors.brown},
    {'name': 'Fast Food', 'icon': Icons.fastfood, 'color': Colors.deepOrange},
    {'name': 'Snacks', 'icon': Icons.cake, 'color': Colors.pinkAccent},
    {
      'name': 'Gym / Fitness',
      'icon': Icons.fitness_center,
      'color': Colors.greenAccent,
    },
    {
      'name': 'Movies',
      'icon': Icons.movie_filter,
      'color': Colors.deepPurpleAccent,
    },
    {'name': 'Gifts', 'icon': Icons.card_giftcard, 'color': Colors.lightGreen},
    {'name': 'Pets', 'icon': Icons.pets, 'color': Colors.amberAccent},
    {
      'name': 'Home Improvement',
      'icon': Icons.home_repair_service,
      'color': Colors.blueGrey,
    },
    {
      'name': 'Hobbies',
      'icon': Icons.sports_esports,
      'color': Colors.orangeAccent,
    },
    {
      'name': 'Charity',
      'icon': Icons.volunteer_activism,
      'color': Colors.purpleAccent,
    },
  ];
}
