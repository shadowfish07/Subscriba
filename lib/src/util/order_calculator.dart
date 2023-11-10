import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/util/duration.dart';
import 'package:subscriba/src/util/payment_calculator.dart';
import 'package:subscriba/src/util/payment_cycle.dart';

class OrderCalculator {
  const OrderCalculator({required this.orders});

  final List<Order> orders;

  get totalPrize {
    return orders.where((e) => e.paymentType == PaymentType.recurring).map((e) {
      final duration =
          Duration.fromDate(e.startDate, e.endDate!, e.paymentCycleType!);

      return PaymentCalculator(
              duration: duration, paymentCycle: e.paymentCycleType!)
          .getTotalPaymentAmount(e.paymentPerPeriod!);
    }).reduce((value, element) => value + element);
  }
}
