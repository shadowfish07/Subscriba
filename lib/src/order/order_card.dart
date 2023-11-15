import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/order_calculator.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, this.color, required this.order});

  final Order order;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        const paymentCycleType2Description = {
          PaymentCycleType.daily: "Daily subscription",
          PaymentCycleType.monthly: "Monthly subscription",
          PaymentCycleType.yearly: "Annual subscription"
        };

        final description = order.description ??
            paymentCycleType2Description[order.paymentCycleType]!;

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
                          description,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "${DateFormatHelper.fromMicrosecondsSinceEpoch(order.startDate)} - ${DateFormatHelper.fromMicrosecondsSinceEpoch(order.endDate!)}",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$${order.paymentPerPeriod.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontFamily: "Alibaba"),
                        ),
                        Text(
                          "+ ${DurationHelper.fromDate(order.startDate, order.endDate!, order.paymentCycleType!).duration} days",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant),
                        )
                      ],
                    ),
                  ],
                )),
              ),
            ),
          ),
        );
      },
    );
  }
}
