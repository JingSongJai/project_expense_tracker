import 'dart:developer';

import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/category_model.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  final _data = ['Edit', 'Delete'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: Responsive.isMobile(context) ? 10 : 20),
        Expanded(
          child: Row(
            children: [
              SizedBox(width: Responsive.isMobile(context) ? 10 : 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Budgets'.tr,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Constant.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (_) => _buildInputDialog(),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: _buildItemsList()),
                    ],
                  ),
                ),
              ),
              SizedBox(width: Responsive.isMobile(context) ? 10 : 20),
            ],
          ),
        ),
        SizedBox(height: Responsive.isMobile(context) ? 10 : 20),
      ],
    );
  }

  Widget _buildBudgetItem(CategoryModel category) {
    double total = Helper.getCategoryTotal(category.name);

    return Container(
      decoration: BoxDecoration(
        color: Color(category.color!).withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(category.color!),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(category.icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton(
                  iconSize: 20,
                  itemBuilder: (context) {
                    return _data
                        .map(
                          (d) => PopupMenuItem(
                            value: d.tr,
                            child: Text(d.tr, style: TextStyle(fontSize: 12)),
                          ),
                        )
                        .toList();
                  },
                  color: Colors.white,
                  onSelected: (value) async {
                    if (value == 'Delete'.tr) {
                      var key = (categoryBox.keys.toList().singleWhere(
                        (key) => categoryBox.get(key).name == category.name,
                      ));
                      if (key != null) {
                        final updatedCategory = categoryBox.get(key);
                        updatedCategory.budget = null;
                        updatedCategory.spent = null;
                        await categoryBox.put(key, updatedCategory);
                        categories.value =
                            categoryBox.values.toList() as List<CategoryModel>;
                        Helper.getNotification();
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearPercentIndicator(
              lineHeight: 5.0,
              percent:
                  total < 0
                      ? (-1 * total) / category.budget! <= 1.0
                          ? (-1 * total) / category.budget!
                          : 1.0
                      : 0,
              backgroundColor: Colors.white,
              progressColor:
                  total < 0 && (-1 * total) / category.budget! < 1.0
                      ? Color(category.color!)
                      : Colors.redAccent,
              barRadius: Radius.circular(10),
              padding: EdgeInsets.zero,
              animation: true,
            ),
            const SizedBox(height: 10),
            Text(
              'Budget : \$ ${category.budget}',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 10),
            Text('Spent/Income : \$ $total', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return ValueListenableBuilder(
      valueListenable: categories,
      builder: (context, value, child) {
        final budgets =
            value.where((category) => category.budget != null).toList();
        if (budgets.isNotEmpty) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  Responsive.isWindow(context)
                      ? 3
                      : Responsive.isTablet(context)
                      ? 2
                      : 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              mainAxisExtent: 140,
            ),
            itemCount: budgets.length,
            itemBuilder: (context, index) => _buildBudgetItem(budgets[index]),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                'assets/json/Empty Icon.json',
                fit: BoxFit.fill,
                width: 200,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Click'),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: 20),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constant.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 10),
                  Text('to add your budgets'),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  final _categoryTextController = TextEditingController();
  final _budgetTextController = TextEditingController();

  Widget _buildInputDialog() {
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text('Add Budgets'.tr, style: TextStyle(fontSize: 20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _budgetTextController,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Budgets'.tr,
              hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                size: 20,
                color: Color(0xFF696969),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title can\'t be empty!'.tr;
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          DropdownMenu(
            controller: _categoryTextController,
            dropdownMenuEntries:
                categories.value
                    .map(
                      (cate) =>
                          DropdownMenuEntry(value: cate, label: cate.name),
                    )
                    .toList(),
            hintText: 'Category'.tr,
            enableFilter: true,
            textStyle: TextStyle(fontSize: 14),
            leadingIcon: Icon(
              Icons.category,
              size: 20,
              color: Color(0xFF696969),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              filled: true,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA3A3A3)),
            ),
            menuHeight: 200,
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.accentColor.withAlpha(200),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            minimumSize: Size.fromHeight(50),
          ),
          child: Text('Cancel'.tr, style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final updatedKey = categoryBox.keys.firstWhere(
              (key) =>
                  categoryBox.get(key).name == _categoryTextController.text,
            );

            if (updatedKey != null) {
              final updatedCategory = categoryBox.get(updatedKey);
              updatedCategory.budget = double.parse(_budgetTextController.text);
              updatedCategory.spent = Helper.getCategoryTotal(
                _categoryTextController.text,
              );
              log('Total : ${updatedCategory.spent}');
              categoryBox.put(updatedKey, updatedCategory);

              categories.value =
                  categoryBox.values.toList() as List<CategoryModel>;
              Helper.getNotification();
            } else {
              print('Category not found!');
            }

            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            minimumSize: Size.fromHeight(50),
          ),
          child: Text('Add'.tr, style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
