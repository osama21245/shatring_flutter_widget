import 'package:custom_paint_practise/shattering_widget.dart';
import 'package:flutter/material.dart';

class DestinationCard extends StatelessWidget {
  final void Function() onScatterComplete;
  const DestinationCard({super.key, required this.onScatterComplete});

  @override
  Widget build(BuildContext context) {
    return ShatteringWidget(
      builder: (shatter) => GestureDetector(
        onTap: shatter,
        child: Container(
          height: 200,
          width: double.infinity,
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/Info_card.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      onScatterComplete: onScatterComplete,
    );
  }
}
