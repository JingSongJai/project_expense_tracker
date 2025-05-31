import 'package:expanse_tracker/data/constant.dart';
import 'package:flutter/material.dart';
import 'package:expanse_tracker/data/responsive.dart';
import '../utils/helper.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final itemHeight = 80.0;

    final crossAxisCount =
        Responsive.isMobile(context)
            ? 1
            : Responsive.isTablet(context)
            ? 2
            : 3;

    final spacing = 10.0;
    final itemWidth =
        (screenWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;

    final aspectRatio = itemWidth / itemHeight;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      itemCount: Constant.expenseCategories.length,
      itemBuilder:
          (context, index) => _buildCategoryItem(
            Constant.expenseCategories[index]['name'],
            Constant.expenseCategories[index]['icon'],
            Constant.expenseCategories[index]['color'],
          ),
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon),
          ),
          title: Text(name, style: TextStyle(fontSize: 14)),
          trailing: Text(
            '\$ ${Helper.getCategoryTotal(name).isNaN ? Helper.getCategoryTotal(name).toInt() : Helper.getCategoryTotal(name).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              color:
                  Helper.getCategoryTotal(name) < 0
                      ? Colors.redAccent
                      : Colors.green,
            ),
          ),
          onTap: () {
            // Handle category tap
          },
        ),
      ),
    );
  }
}
