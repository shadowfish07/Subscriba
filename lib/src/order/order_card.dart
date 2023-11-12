import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Center(
                child: Text(
              "Order",
              style: Theme.of(context).textTheme.titleMedium,
            )),
          ),
        ),
      ),
    );
  }
}
