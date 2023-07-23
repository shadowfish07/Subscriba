import { Appbar, FAB } from "react-native-paper";
import { SubscriptionItem } from "../../components/subscriptionItem";
import { ScrollView, StyleSheet, View } from "react-native";
import {
  ParamListBase,
  useFocusEffect,
  useNavigation,
} from "@react-navigation/native";
import { NativeStackNavigationProp } from "@react-navigation/native-stack";
import { useData } from "../../hooks/useData";
import { usePerUnit } from "../../hooks/usePerUnit";
import { OrdersModal } from "../../modals";
import { Money } from "../../util/money";

export const Home = () => {
  const navigation = useNavigation<NativeStackNavigationProp<ParamListBase>>();
  const { calculateServicesPerCost, calculateBuyoutCost } = usePerUnit(true);
  const { data: subscriptions } = useData("getSubscriptionList", []);

  const calculateExtraCost = (orders: OrdersModal[]) => {
    const buyoutCost = calculateBuyoutCost(orders);
    if (new Money(buyoutCost).getValue() > 0) {
      return `+${calculateBuyoutCost(orders)}买断`;
    }

    return "";
  };

  return (
    <>
      <ScrollView>
        {(subscriptions || []).map((subscription) => (
          <SubscriptionItem
            cost={calculateServicesPerCost(subscription.services)}
            key={subscription.id}
            subscription={subscription}
            extraCost={calculateExtraCost(subscription.orders)}
          />
        ))}
      </ScrollView>
      <FAB
        icon="plus"
        style={styles.fab}
        onPress={() => navigation.push("subscription-add")}
      />
    </>
  );
};

const styles = StyleSheet.create({
  fab: {
    position: "absolute",
    margin: 16,
    right: 0,
    bottom: 0,
  },
});
