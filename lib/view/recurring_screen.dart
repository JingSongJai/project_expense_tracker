import 'package:expanse_tracker/controller/notification_controller.dart';
import 'package:expanse_tracker/data/box.dart';
import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/data/responsive.dart';
import 'package:expanse_tracker/main.dart';
import 'package:expanse_tracker/model/recure_model.dart';
import 'package:expanse_tracker/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class RecurringPaymentScreen extends StatefulWidget {
  const RecurringPaymentScreen({super.key});

  @override
  State<RecurringPaymentScreen> createState() => _RecurringPaymentScreenState();
}

class _RecurringPaymentScreenState extends State<RecurringPaymentScreen> {
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Your Recurring Payments'.tr,
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
                      Expanded(child: _buildItemList()),
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

  Widget _buildItemList() {
    return ValueListenableBuilder(
      valueListenable: recures,
      builder: (context, value, child) {
        if (value.isNotEmpty) {
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
              mainAxisExtent: 210,
            ),
            itemCount: recures.value.length,
            itemBuilder: (context, index) => _buildItem(recures.value[index]),
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
                  AbsorbPointer(
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white, size: 20),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constant.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('to add your recurring payments'),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildItem(RecureModel recure) {
    final category = categories.value.singleWhere(
      (category) => category.name == recure.category,
    );
    ValueNotifier<bool> isRemind = ValueNotifier(recure.isRemind);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(category.color ?? 0xFF000000).withAlpha(30),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(category.icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recure.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${recure.category} ∙ ${recure.frequency.tr}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder(
                valueListenable: isRemind,
                builder:
                    (context, value, child) => Transform.scale(
                      scale: 0.7,
                      child: Switch.adaptive(
                        activeColor: Constant.primaryColor,
                        value: isRemind.value,
                        onChanged: (value) async {
                          final key = recureBox.keys.singleWhere(
                            (key) => recureBox.get(key).uuid == recure.uuid,
                          );

                          var updatedRecure = recureBox.get(key);
                          updatedRecure.isRemind = !isRemind.value;

                          await recureBox.put(key, updatedRecure);

                          recures.value =
                              recureBox.values.toList() as List<RecureModel>;

                          isRemind.value = !isRemind.value;

                          if (isRemind.value) {
                            await NotificationController.setMultiScheduledNotification(
                              recure,
                            );
                          } else {
                            await NotificationController.cancelNotification(
                              updatedRecure.uuid,
                              Helper.getAmountOfScheduledNotification(recure),
                            );
                          }
                        },
                        applyCupertinoTheme: true,
                        padding: EdgeInsets.zero,
                      ),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildItemBox(
                  Color(category.color ?? 0xFF000000),
                  'Amount'.tr,
                  recure.amount.toString(),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildItemBox(
                  Color(category.color ?? 0xFF000000),
                  'Next Due'.tr,
                  DateFormat('yyyy-MM-dd').format(
                    recure.startDate.add(
                      Helper.getDuration(
                        recure.frequency.trim(),
                        recure.startDate,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: _buildItemBox(
                  Color(category.color ?? 0xFF000000),
                  'Total'.tr,
                  recure.total.toString(),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _buildItemBox(
                  Color(category.color ?? 0xFF000000),
                  'End Date'.tr,
                  DateFormat('yyyy-MM-dd').format(recure.endDate),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton('Edit', recure),
              _buildButton(recure.isPaused ? 'Resume' : 'Pause', recure),
              _buildButton('Delete', recure),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String tooltip, RecureModel recure) {
    ValueNotifier<String> value = ValueNotifier(tooltip);

    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: ValueListenableBuilder(
          valueListenable: value,
          builder:
              (context, value, child) => Icon(
                value == 'Edit'
                    ? Icons.edit
                    : value == 'Delete'
                    ? Icons.delete
                    : value == 'Pause'
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
        ),
        onPressed: () async {
          switch (value.value) {
            case 'Delete':
              final key = recureBox.keys.singleWhere(
                (key) => recureBox.get(key).uuid == recure.uuid,
              );

              if (key != null) {
                await recureBox.delete(key);

                recures.value = recureBox.values.toList() as List<RecureModel>;
              }
              break;
            case 'Pause':
              value.value = 'Resume';
              await Helper.updateRecurePause(recure, value.value);
              break;
            case 'Resume':
              value.value = 'Pause';
              await Helper.updateRecurePause(recure, value.value);
              break;
            case 'Edit':
              NotificationController.cancelNotification(1, 1);
              break;
          }
        },
      ),
    );
  }

  Widget _buildItemBox(Color color, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color.withAlpha(100),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 11)),
          const SizedBox(height: 2),
          Text(
            double.tryParse(subtitle) != null
                ? '\$ $subtitle'
                : subtitle.trim(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  final _categoryTextController = TextEditingController();
  final _titleTextController = TextEditingController();
  final _freqTextController = TextEditingController();
  final _amountTextController = TextEditingController();
  ValueNotifier<DateTime> startDate = ValueNotifier(DateTime.now());
  ValueNotifier<DateTime> endDate = ValueNotifier(DateTime.now());
  final _freq = ['Weekly                  ', 'Monthly', 'Yearly'];

  Widget _buildInputDialog() {
    return AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text('Add Recurring Payment', style: TextStyle(fontSize: 20)),
      content: Column(
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
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              prefixIcon: Icon(
                Icons.attach_money_rounded,
                size: 20,
                color: Color(0xFF696969),
              ),
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
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              prefixIcon: Icon(
                Icons.numbers,
                size: 20,
                color: Color(0xFF696969),
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
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
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              filled: true,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA3A3A3)),
            ),
            menuHeight: 200,
          ),
          const SizedBox(height: 10),
          DropdownMenu(
            controller: _freqTextController,
            dropdownMenuEntries:
                _freq
                    .map(
                      (value) => DropdownMenuEntry(value: value, label: value),
                    )
                    .toList(),
            hintText: 'Frequency',
            enableFilter: true,
            textStyle: TextStyle(fontSize: 14),
            leadingIcon: Icon(
              Icons.watch_later_rounded,
              size: 20,
              color: Color(0xFF696969),
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              filled: true,
              hintStyle: TextStyle(fontSize: 14, color: Color(0xFFA3A3A3)),
            ),
            menuHeight: 200,
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _buildDateTime(false);
            },
            borderRadius: BorderRadius.circular(5),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text('Start Date'),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: startDate,
                    builder:
                        (context, value, child) =>
                            Text(DateFormat('dd-MM-yyyy').format(value)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              _buildDateTime(true);
            },
            borderRadius: BorderRadius.circular(5),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Text('End Date'),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: endDate,
                    builder:
                        (context, value, child) =>
                            Text(DateFormat('dd-MM-yyyy').format(value)),
                  ),
                ],
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
          child: Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final recure = RecureModel(
              uuid: DateTime.now().millisecondsSinceEpoch,
              title: _titleTextController.text,
              category: _categoryTextController.text.trim(),
              startDate: startDate.value,
              endDate: endDate.value,
              frequency: _freqTextController.text,
              isRemind: false,
              amount: double.parse(_amountTextController.text),
              isPaused: false,
              total: double.parse(_amountTextController.text),
            );

            await recureBox.add(recure);

            recures.value = recureBox.values.toList() as List<RecureModel>;

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

  void _buildDateTime(bool isEndDate) async {
    final result = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      initialDate: isEndDate ? endDate.value : startDate.value,
    );

    if (result != null) {
      if (isEndDate) {
        endDate.value = result;
      } else {
        startDate.value = result;
      }
    }
  }
}
