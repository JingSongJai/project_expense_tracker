import 'package:flutter/material.dart';

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
  bool isHover = false;
  double value = 10;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          if (!isHover) value += 3;
          isHover = true;
        });
      },
      onExit: (_) {
        setState(() {
          if (isHover) value -= 3;
          isHover = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [widget.firstColor, widget.secondColor],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: value - 7,
              color: Colors.grey.shade400,
              offset: Offset(0, value - 10),
            ),
          ],
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
            AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.all(value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.title, style: TextStyle(fontSize: 11)),
                      const Spacer(),
                      Icon(widget.icon, size: 20),
                    ],
                  ),
                  Text(
                    widget.number,
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
      ),
    );
  }
}
