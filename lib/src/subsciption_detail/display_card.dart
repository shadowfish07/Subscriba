import 'package:flutter/material.dart';

class DisplayCard extends StatelessWidget {
  const DisplayCard(
      {super.key,
      required this.title,
      required this.body,
      this.color,
      this.onTap});

  final Widget title;
  final Widget body;
  final Color? color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    var card = Card(
      color: color ?? Theme.of(context).colorScheme.surfaceVariant,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SizedBox(
            height: 64,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                body,
              ],
            ),
          ),
        ),
      ),
    );

    return card;
  }
}
