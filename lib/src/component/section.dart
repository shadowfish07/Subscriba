import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subscriba/src/styles/styles.dart';

class Section extends StatelessWidget {
  const Section({super.key, required this.title, required this.child});

  final String title;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultCenterPadding.add(EdgeInsets.only(bottom: 16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        child
      ]),
    );
  }
}
