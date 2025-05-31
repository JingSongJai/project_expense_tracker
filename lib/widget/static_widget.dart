import 'package:flutter/material.dart';

class StatisWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [firstColor, secondColor]),
        borderRadius: BorderRadius.circular(5),
      ),
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: TextStyle(fontSize: 11)),
                    const Spacer(),
                    Icon(icon, size: 15),
                  ],
                ),
                Text(
                  number,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                Text('View Detail', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
