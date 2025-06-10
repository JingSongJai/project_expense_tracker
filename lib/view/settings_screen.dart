import 'package:expanse_tracker/data/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings'.tr,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      _buildLanguageItem(),
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

  Widget _buildLanguageItem() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/svg/Language Icon.svg',
                colorFilter: ColorFilter.mode(
                  Color(0xFF696969),
                  BlendMode.srcIn,
                ),
                width: 25,
              ),
              const SizedBox(width: 10),
              Text('Language'.tr, style: TextStyle(fontSize: 13)),
            ],
          ),
          DropdownButton<String>(
            value: selectedLanguage,
            items: [
              DropdownMenuItem(
                value: 'English',
                child: Text('English', style: TextStyle(fontSize: 13)),
              ),
              DropdownMenuItem(
                value: 'Khmer',
                child: Text('Khmer', style: TextStyle(fontSize: 13)),
              ),
            ],
            onChanged: (value) {
              if (value! == 'English') {
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
          ),
        ],
      ),
    );
  }
}
