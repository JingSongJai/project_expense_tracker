import 'dart:developer';

import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/icon_data.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/category_model.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/widget/transaction_widget.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    return Column(
      children: [
        const SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.grey.shade300,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: categories,
                    builder:
                        (context, value, child) => Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Transactions',
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
                                      builder:
                                          (_) => _buildCategoryInputDialog(),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      mainAxisSpacing: spacing,
                                      crossAxisSpacing: spacing,
                                      childAspectRatio: aspectRatio,
                                    ),
                                itemCount: categories.value.length,
                                itemBuilder:
                                    (context, index) => _buildCategoryItem(
                                      categories.value[index].name,
                                      categories.value[index].icon ??
                                          Icons.help_center,
                                      Color(categories.value[index].color!),
                                    ),
                              ),
                            ),
                          ],
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategoryItem(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 20),
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Text(
            '\$ ${Helper.getCategoryTotal(name).isNaN ? Helper.getCategoryTotal(name).toInt() : Helper.getCategoryTotal(name).toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              color:
                  Helper.getCategoryTotal(name) < 0
                      ? Colors.redAccent
                      : Colors.green,
            ),
          ),
          onTap: () async {
            await showDialog(
              context: context,
              builder: (_) => _buildCategoryInfoDialog(name, icon, color),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryInfoDialog(String title, IconData icon, Color color) {
    final list =
        expenses.value.where((expense) => expense.category == title).toList();
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      title: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
      content:
          list.isEmpty
              ? Padding(
                padding: const EdgeInsets.all(50.0),
                child: SvgPicture.asset(
                  'assets/svg/Empty Icon.svg',
                  colorFilter: ColorFilter.mode(
                    Colors.redAccent,
                    BlendMode.srcIn,
                  ),
                  width: 100,
                ),
              )
              : SizedBox(
                height: 350,
                width: 340,
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: list.length,
                  itemBuilder:
                      (context, index) => TransactionItem(
                        expense: list[index],
                        index: index,
                        isEdited: true,
                      ),
                ),
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
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final key = categoryBox.keys.singleWhere(
              (key) => categoryBox.get(key).name == title,
            );

            if (key != null) {
              await categoryBox.delete(key);
              for (final value in list) {
                final key = expenseBox.keys.firstWhere(
                  (key) => expenseBox.get(key).uuid == value.uuid,
                  orElse: () => null,
                );
                log('UUID : ${value.uuid} = $key');

                if (key != null) await expenseBox.delete(key);
              }
              categories.value =
                  categoryBox.values.toList() as List<CategoryModel>;
              expenses.value = expenseBox.values.toList() as List<ExpenseModel>;

              if (mounted) Navigator.pop(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            minimumSize: Size.fromHeight(50),
          ),
          child: Text('Delete Category', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  ValueNotifier<IconData> selectedIconData = ValueNotifier<IconData>(
    iconData.first,
  );
  Color selectedColor = Colors.blue;
  final _cateNameController = TextEditingController();

  Widget _buildCategoryInputDialog() {
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.white,
      title: Text('Add Category', style: TextStyle(fontSize: 20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _cateNameController,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Category Name',
              hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Constant.backgroundColor,
              prefixIcon: InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => _buildIconDataDialog(),
                  );
                },
                child: ValueListenableBuilder(
                  valueListenable: selectedIconData,
                  builder:
                      (context, value, child) => Icon(selectedIconData.value),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title can\'t be empty!';
              }
              return null;
            },
          ),
          ColorPicker(
            onColorChanged: (value) {
              selectedColor = value;
            },
            color: selectedColor,
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
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_cateNameController.text.isEmpty) return;

            bool isExisted = categories.value.any(
              (category) =>
                  category.name.toLowerCase().compareTo(
                    _cateNameController.text.toLowerCase(),
                  ) ==
                  0,
            );

            if (isExisted) return;

            final category = CategoryModel(
              name: _cateNameController.text,
              iconCodePoint: selectedIconData.value.codePoint,
              fontFamily: selectedIconData.value.fontFamily,
              fontPackage: selectedIconData.value.fontPackage,
              color: selectedColor.value32bit,
            );

            await categoryBox.add(category);

            categories.value =
                categoryBox.values.toList() as List<CategoryModel>;

            if (mounted) Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constant.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            minimumSize: Size.fromHeight(50),
          ),
          child: Text('Add', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildIconDataDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.white,
      title: Text('Choose Icon', style: TextStyle(fontSize: 20)),
      content: SizedBox(
        height: 200,
        width: 100,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: iconData.length,
          itemBuilder:
              (context, index) => InkWell(
                onTap: () {
                  selectedIconData.value = iconData[index];
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Icon(iconData[index]),
              ),
        ),
      ),
    );
  }
}
