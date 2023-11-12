import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, this.color});

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: color,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Annual subscription",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "02/02/2012 - 02/03/2012",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$780",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "+ 30 days",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    )
                  ],
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
