import 'package:expanse_tracker/data/constant.dart';
import 'package:expanse_tracker/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({super.key});

  @override
  State<SideBarWidget> createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  var menus = Constant.menus;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          'assets/svg/Logo Icon.svg',
          colorFilter: ColorFilter.mode(Constant.primaryColor, BlendMode.srcIn),
        ),
      ),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minExtendedWidth: 220,
      extended: Constant.isExtended,
      backgroundColor: Colors.white,
      destinations: List.generate(Constant.menus.length, (index) {
        return NavigationRailDestination(
          icon: SvgPicture.asset(
            Constant.menus[index]['icon']!,
            colorFilter: ColorFilter.mode(
              selectedIndex.value == index
                  ? Constant.primaryColor
                  : Color(0xFF696969),
              BlendMode.srcIn,
            ),
            width: 18,
          ),
          label: Text(
            menus[index]['title']!,
            style: TextStyle(
              fontSize: 13,
              color:
                  selectedIndex.value == index
                      ? Constant.primaryColor
                      : Color(0xFF696969),
              fontWeight:
                  selectedIndex.value == index
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),
        );
      }),
      selectedIndex: selectedIndex.value,
      onDestinationSelected:
          (index) => setState(() {
            selectedIndex.value = index;
          }),
    );
  }
}
