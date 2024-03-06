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
      this.titleSize = TitleSize.h1,
      this.action = const SizedBox.shrink()}) {
    this.padding =
        padding ?? defaultCenterPadding.add(const EdgeInsets.only(bottom: 16));
    this.titleBottomMargin = titleBottomMargin ?? 8;
  }

  factory Section.subSectionH2(
      {key,
      required String title,
      required Widget child,
      double? titleBottomMargin,
      Widget action = const SizedBox.shrink()}) {
    return Section(
        key: key,
        title: title,
        padding: const EdgeInsets.all(0),
        titleSize: TitleSize.h2,
        titleBottomMargin: titleBottomMargin,
        action: action,
        child: child);
  }

  final String title;

  final Widget child;

  late final EdgeInsetsGeometry padding;

  final TitleSize titleSize;

  late final double titleBottomMargin;

  final Widget action;

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: titleStyles[titleSize],
              ),
              action,
            ],
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
