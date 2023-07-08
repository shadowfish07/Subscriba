import { Card, Button, Text } from "react-native-paper";
import { StyleSheet, View } from "react-native";
import { MoneyWithPerCost } from "./moneyWithPerCost";
import { ParamListBase, useNavigation } from "@react-navigation/native";
import type { NativeStackNavigationProp } from "@react-navigation/native-stack";
import { globalStyles } from "../styles";
import { Subscription } from "../types";

type Props = {
  subscription: Subscription;
  cost: string;
  extraCost?: string;
};

export const SubscriptionItem = ({ subscription, cost, extraCost }: Props) => {
  const navigation = useNavigation<NativeStackNavigationProp<ParamListBase>>();

  return (
    <Card
      style={globalStyles.card}
      onPress={() => {
        navigation.push("subscription-detail", {
          id: subscription.id,
          appName: subscription.appName,
        });
      }}
    >
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          paddingVertical: 20,
        }}
      >
        <View>
          <Text variant="titleLarge" style={{ paddingLeft: 15 }}>
            {subscription.appName}
          </Text>
        </View>
        <View style={{ alignItems: "flex-end" }}>
          <Text variant="titleLarge" style={{ paddingRight: 15 }}>
            {cost}
          </Text>
          {extraCost && <Text style={{ paddingRight: 15 }}>{extraCost}</Text>}
        </View>
      </View>
    </Card>
  );
};
