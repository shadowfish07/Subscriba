import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subscriba/src/styles/styles.dart';

class HomeSection extends StatelessWidget {
  const HomeSection({super.key, required this.title, required this.children});

  final String title;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: defaultCenterPadding,
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
        ...children
      ]),
    );
  }
}
