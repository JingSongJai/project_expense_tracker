import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisWidget extends StatefulWidget {
  const StatisWidget({
    super.key,
    required this.title,
    required this.number,
    required this.firstColor,
    required this.secondColor,
    required this.icon,
  });
  final String title, number;
  final Color firstColor, secondColor;
  final IconData icon;

  @override
  State<StatisWidget> createState() => _StatisWidgetState();
}

class _StatisWidgetState extends State<StatisWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.firstColor, widget.secondColor],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(75),
              ),
            ),
          ),
          Positioned(
            right: -20,
            top: 60,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(75),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.title.tr, style: TextStyle(fontSize: 11)),
                    const Spacer(),
                    Icon(widget.icon, size: 20),
                  ],
                ),
                Text(
                  widget.title.tr == 'Category'.tr
                      ? widget.number
                      : 'amount'.trParams({'number': widget.number}),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
