import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/view/category_screen.dart';
import 'package:expanse_tracker/view/home_screen.dart';
import 'package:expanse_tracker/view/transaction_screen.dart';
import 'package:expanse_tracker/widget/sidebar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

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
      floatingActionButton: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder: (context, value, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child:
                selectedIndex.value == 1
                    ? FloatingActionButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => _buildInputDialog(),
                        );
                      },
                      backgroundColor: Constant.accentColor,
                      child: Icon(Icons.add, color: Colors.white),
                    )
                    : null,
          );
        },
      ),
    );
  }

  Widget buildSideBarMenu() {
    return SideBarWidget();
  }

  Widget buildBottomMenu() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(4, (index) {
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
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex.value = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              path,
              colorFilter: ColorFilter.mode(
                selectedIndex.value == index
                    ? Constant.primaryColor
                    : Color(0xFF696969),
                BlendMode.srcIn,
              ),
              width: 22,
            ),
            Text(
              Constant.menus[index]['title']!,
              style: TextStyle(
                color:
                    selectedIndex.value == index
                        ? Constant.primaryColor
                        : Color(0xFF696969),
              ),
            ),
          ],
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
          if (Responsive.isWindow(context) || Responsive.isTablet(context))
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      'assets/svg/Search Icon.svg',
                      colorFilter: ColorFilter.mode(
                        Color(0xFFA3A3A3),
                        BlendMode.srcIn,
                      ),
                      width: 20,
                    ),
                  ),
                ),
              ),
            ),
          const Spacer(),
          if (Responsive.isMobile(context))
            SvgPicture.asset(
              'assets/svg/Search Icon.svg',
              colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
            ),
          if (Responsive.isMobile(context)) const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              var result = Helper.getAmountByCategory(false);
              print(result);
            },
            child: SvgPicture.asset(
              'assets/svg/Notification Icon.svg',
              colorFilter: ColorFilter.mode(
                Constant.primaryColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  Widget _buildPageDisplay() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ValueListenableBuilder(
        valueListenable: selectedIndex,
        builder:
            (context, value, child) => AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _getDisplayPage(value),
            ),
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
        widget = HomeScreen();
        break;

      case 4:
      case 5:
      case 6:
      case 7:
        widget = HomeScreen();
        break;
    }

    return widget!;
  }

  Widget _buildInputDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.white,
      title: Text('Add Transaction', style: TextStyle(fontSize: 20)),
      content: _buildContent(),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _clearInputText();
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
            if (!_formState.currentState!.validate()) return;

            final expense = ExpenseModel(
              title: _titleTextController.text,
              amount: double.parse(_amountTextController.text),
              category: _categoryTextController.text,
              date: date,
            );

            await expenseBox.add(expense);
            expenses.value = expenseBox.values.toList() as List<ExpenseModel>;

            if (mounted) Navigator.pop(context);
            _clearInputText();
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

  DateTime date = DateTime.now();
  final _titleTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  final _categoryTextController = TextEditingController();
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  void _clearInputText() {
    _titleTextController.text =
        _amountTextController.text = _categoryTextController.text = '';
  }

  Widget _buildContent() {
    return Form(
      key: _formState,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _titleTextController,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Constant.backgroundColor,
              prefixIcon: Icon(Icons.title, size: 20, color: Color(0xFF696969)),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title can\'t be empty!';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _amountTextController,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Amount',
              hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
              border: OutlineInputBorder(borderSide: BorderSide.none),
              filled: true,
              fillColor: Constant.backgroundColor,
              prefixIcon: Icon(
                Icons.numbers,
                size: 20,
                color: Color(0xFF696969),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final text = newValue.text;

                // Allow only digits and one optional hyphen at the beginning
                final isValid = RegExp(r'^-?\d*$').hasMatch(text);

                return isValid ? newValue : oldValue;
              }),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Amount can\'t be empty!';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          DropdownMenu(
            controller: _categoryTextController,
            dropdownMenuEntries:
                Constant.expenseCategories
                    .map(
                      (cate) =>
                          DropdownMenuEntry(value: cate, label: cate['name']),
                    )
                    .toList(),
            hintText: 'Category',
            enableFilter: true,
            textStyle: TextStyle(fontSize: 14),
            leadingIcon: Icon(
              Icons.category,
              size: 20,
              color: Color(0xFF696969),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Constant.backgroundColor,
              filled: true,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA3A3A3)),
            ),
            menuHeight: 200,
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _buildDateTime();
            },
            borderRadius: BorderRadius.circular(5),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Constant.backgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text(DateFormat('dd-MM-yyyy').format(date)),
                  const Spacer(),
                  Icon(
                    Icons.date_range_rounded,
                    size: 20,
                    color: Color(0xFF696969),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buildDateTime() async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      initialDate: date,
    );

    if (result != null) {
      setState(() {
        date = result;
        print(date);
      });
    }
  }
}
