import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:subscriba/src/styles/styles.dart';

enum TitleSize { h1, h2 }

class Section extends StatelessWidget {
  Section(
      {super.key,
      required this.title,
      required this.child,
      EdgeInsetsGeometry? padding,
      this.titleSize = TitleSize.h1}) {
    this.padding =
        padding ?? defaultCenterPadding.add(const EdgeInsets.only(bottom: 16));
  }

  factory Section.subSectionH2({
    key,
    required String title,
    required Widget child,
  }) {
    return Section(
      key: key,
      title: title,
      padding: const EdgeInsets.all(0),
      titleSize: TitleSize.h2,
      child: child,
    );
  }

  final String title;

  final Widget child;

  late final EdgeInsetsGeometry padding;

  final TitleSize titleSize;

  @override
  Widget build(BuildContext context) {
    var titleStyles = {
      TitleSize.h1: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: Theme.of(context).colorScheme.primary),
      TitleSize.h2: Theme.of(context)
          .textTheme
          .titleMedium!
          .copyWith(color: Theme.of(context).colorScheme.primary),
    };

    return Container(
      padding: padding,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: titleStyles[titleSize],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        child
      ]),
    );
  }
}
