import 'package:flutter/material.dart';
import 'package:subscriba/src/styles/styles.dart';

enum TitleSize { h1, h2 }

class Section extends StatelessWidget {
  Section(
      {super.key,
      required this.title,
      required this.child,
      EdgeInsetsGeometry? padding,
      double? titleBottomMargin,
      this.titleSize = TitleSize.h1}) {
    this.padding =
        padding ?? defaultCenterPadding.add(const EdgeInsets.only(bottom: 16));
    this.titleBottomMargin = titleBottomMargin ?? 8;
  }

  factory Section.subSectionH2({
    key,
    required String title,
    required Widget child,
    double? titleBottomMargin,
  }) {
    return Section(
        key: key,
        title: title,
        padding: const EdgeInsets.all(0),
        titleSize: TitleSize.h2,
        titleBottomMargin: titleBottomMargin,
        child: child);
  }

  final String title;

  final Widget child;

  late final EdgeInsetsGeometry padding;

  final TitleSize titleSize;

  late final double titleBottomMargin;

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
        SizedBox(
          height: titleBottomMargin,
        ),
        child
      ]),
    );
  }
}
