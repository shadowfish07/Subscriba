import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:subscriba/src/component/money_text.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/order/order_edit.dart';
import 'package:subscriba/src/util/date_format_helper.dart';
import 'package:subscriba/src/util/duration.dart';

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
        const paymentFrequency2Description = {
          PaymentFrequency.daily: "Daily subscription",
          PaymentFrequency.monthly: "Monthly subscription",
          PaymentFrequency.yearly: "Annual subscription",
          PaymentFrequency.oneTime: "One-time purchase",
        };

        final description = order.description ??
            paymentFrequency2Description[order.paymentFrequency] ??
            "Lifetime subscription";

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
                          order.paymentType == PaymentType.lifetime
                              ? "${DateFormatHelper.fromMicrosecondsSinceEpoch(order.startDate)} - ∞"
                              : "${DateFormatHelper.fromMicrosecondsSinceEpoch(order.startDate)} - ${DateFormatHelper.fromMicrosecondsSinceEpoch(order.endDate!)}",
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
                        MoneyText(
                          money: order.paymentPerPeriod,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          order.paymentType == PaymentType.lifetime
                              ? "lifetime"
                              : "+ ${DurationHelper.fromDate(order.startDate, order.endDate!, order.paymentFrequency!).duration} days",
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
