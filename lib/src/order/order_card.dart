import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/order/order_edit.dart';
import 'package:subscriba/src/store/subscription_model.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/order_calculator.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
      {super.key, this.color, this.onDelete, this.onEdit, required this.order});

  final Order order;
  final Color? color;
  final Function? onDelete;
  final Function? onEdit;
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

        Future<bool?> showConfirmDialog() async {
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Delete Order?'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('This operation is irreversible'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Delete'),
                    onPressed: () async {
                      Navigator.of(context).pop(true);
                      onDelete?.call(order.id);
                    },
                  ),
                ],
              );
            },
          );
        }

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => SizedBox(
                      height: 160,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderEdit(
                                          orderId: order.id,
                                        )),
                              );
                              Navigator.of(context).pop();
                              onEdit?.call(order.id);
                            },
                            child: const ListTile(
                              leading: Icon(Icons.edit),
                              title: Text("Edit"),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              final result = await showConfirmDialog();
                              if (result == true) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const ListTile(
                              leading: Icon(Icons.delete),
                              title: Text("Delete"),
                            ),
                          )
                        ]),
                      ),
                    ));
          },
          child: Card(
            color: color ?? Theme.of(context).colorScheme.surfaceVariant,
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
