import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:subscriba/src/add_subscription/form_model.dart';
import 'package:subscriba/src/order/lifetime_tab.dart';
import 'package:subscriba/src/order/recurring_tab.dart';
import 'package:subscriba/src/component/section.dart';
import 'package:subscriba/src/database/order.dart';
import 'package:subscriba/src/database/subscription.dart';
import 'package:subscriba/src/store/subscriptions_model.dart';
import 'package:subscriba/src/styles/styles.dart';

class AddSubscriptionForm extends StatefulWidget {
  const AddSubscriptionForm({
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => _AddSubscriptionFormState();
}

class _AddSubscriptionFormState extends State<AddSubscriptionForm>
    with TickerProviderStateMixin {
  _AddSubscriptionFormState();

  late final TabController paymentTypeTabController;

  @override
  void initState() {
    super.initState();
    paymentTypeTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final formModel = Provider.of<FormModel>(context);
    final subscriptionsModel = Provider.of<SubscriptionsModel>(context);

    Future<bool> saveSubscription() async {
      formModel.validateAll();

      if (!formModel.error.hasErrors) {
        final subscriptionId = await SubscriptionProvider().insert(
            Subscription.create(
                title: formModel.subscriptionName!,
                description: formModel.subscriptionDescription));

        await OrderProvider().insert(
          Order.create(
              orderDate: formModel.startTimeTimestamp!,
              paymentType: formModel.paymentType,
              startDate: formModel.startTimeTimestamp!,
              endDate: formModel.endTimeTimestamp,
              subscriptionId: subscriptionId,
              paymentCurrencyPerPeriod: "\$",
              paymentFrequency: formModel.paymentFrequency,
              paymentPerPeriod: formModel.paymentPerPeriod),
        );

        subscriptionsModel.loadSubscriptions();

        return true;
      }

      return false;
    }

    return ListView(
      children: [
        Padding(
          padding: defaultCenterPadding
              .add(const EdgeInsets.symmetric(vertical: 16)),
          child: Observer(builder: (context) {
            return TextField(
                onChanged: (value) => formModel.subscriptionName = value,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Subscription Name',
                    errorText: formModel.error.subscriptionName));
          }),
        ),
        Padding(
          padding: defaultCenterPadding.add(const EdgeInsets.only(bottom: 16)),
          child: TextField(
              onChanged: (value) => formModel.subscriptionDescription = value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subscription Description',
              )),
        ),
        const SizedBox(height: 8),
        Section(
          title: "Add Order",
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Observer(builder: (context) {
                    return SegmentedButton<PaymentType>(
                      selected: <PaymentType>{formModel.paymentType},
                      segments: const [
                        ButtonSegment(
                            value: PaymentType.recurring,
                            label: Text("Recurring")),
                        ButtonSegment(
                            value: PaymentType.lifetime,
                            label: Text("Lifetime"))
                      ],
                      onSelectionChanged: (value) {
                        formModel.setPaymentType(value.first);
                      },
                    );
                  }),
                ),
                const SizedBox(
                  height: 16,
                ),
                Observer(
                    builder: (_) =>
                        formModel.paymentType == PaymentType.recurring
                            ? const RecurringTab()
                            : const LifetimeTab()),
                SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                        onPressed: () {
                          saveSubscription().then((isSuccess) {
                            if (!isSuccess) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Subscription Added'),
                                width: 170.0, // Width of the SnackBar.
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          });
                        },
                        child: const Text("Save"))),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
