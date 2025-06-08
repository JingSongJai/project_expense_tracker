import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/expense_model.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:expanse_tracker/widget/transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildItems();
  }

  final _dataSort = ['Date', 'Name', 'Category', 'Amount'];
  final _dataGroup = ['Day', 'Month', 'Year', 'Category'];

  bool isShowCheckBox = false;

  Widget _buildItems() {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Transactions',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          _buildGroup(),
                          const SizedBox(width: 10),
                          _buildSort(),
                          const SizedBox(width: 10),
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
                      ValueListenableBuilder(
                        valueListenable: expenses,
                        builder: (context, value, child) {
                          if (value.isNotEmpty) {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: expenses.value.length,
                                itemBuilder:
                                    (context, index) => TransactionItem(
                                      expense: expenses.value[index],
                                      index: index,
                                      isEdited: true,
                                    ),
                              ),
                            );
                          } else {
                            return Expanded(
                              child: Column(
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
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constant.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                      const SizedBox(width: 10),
                                      Text('to add your transactions'),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
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

  Widget _buildSort() {
    return PopupMenuButton(
      tooltip: 'Sort',
      icon: SvgPicture.asset(
        'assets/svg/Sort Icon.svg',
        colorFilter: ColorFilter.mode(Color(0xFFA3A3A3), BlendMode.srcIn),
      ),
      itemBuilder:
          (context) => List.generate(_dataSort.length, (index) {
            return PopupMenuItem(
              child: Text(_dataSort[index], style: TextStyle(fontSize: 12)),
            );
          }),
      onSelected: (value) {},
      color: Colors.white,
    );
  }

  Widget _buildGroup() {
    return PopupMenuButton(
      tooltip: 'Group',
      icon: SvgPicture.asset(
        'assets/svg/Group Icon.svg',
        colorFilter: ColorFilter.mode(Color(0xFFA3A3A3), BlendMode.srcIn),
        width: 20,
      ),
      itemBuilder:
          (context) => List.generate(_dataGroup.length, (index) {
            return PopupMenuItem(
              child: Text(_dataGroup[index], style: TextStyle(fontSize: 12)),
            );
          }),
      color: Colors.white,
    );
  }

  Widget _buildInputDialog() {
    return AlertDialog.adaptive(
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
              uuid: DateTime.now().millisecondsSinceEpoch,
              title: _titleTextController.text,
              amount: double.parse(_amountTextController.text),
              category: _categoryTextController.text,
              date: date,
            );

            await expenseBox.add(expense);
            expenses.value = expenseBox.values.toList() as List<ExpenseModel>;
            Helper.getNotification();

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
                categories.value
                    .map(
                      (cate) =>
                          DropdownMenuEntry(value: cate, label: cate.name),
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
