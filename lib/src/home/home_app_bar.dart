import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});
  final double _prefHeight = 120.0;
  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(top: statusBarHeight + 16, left: 24),
        height: _prefHeight + statusBarHeight,
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$100,00.68',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  'per year',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            )
          ],
        ));
  }

  @override
  Size get preferredSize => Size.fromHeight(_prefHeight);
}
