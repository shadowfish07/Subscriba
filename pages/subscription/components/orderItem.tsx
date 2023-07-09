import { Card, Text, useTheme } from "react-native-paper";
import { DraftOrder, OrderType } from "../../../types";
import { formatDate } from "../../../util/formatDate";
import { View } from "react-native";
import { rawTimeExtension2String } from "../../../util/rawTimeExtension2String";

type Props = {
  draftOrder: DraftOrder;
};

export const OrderItem = ({ draftOrder }: Props) => {
  const theme = useTheme();
  return (
    <Card style={{ backgroundColor: "rgba(73, 69, 79, 1)", marginBottom: 10 }}>
      <Card.Content>
        <View style={{ flexDirection: "row", justifyContent: "space-between" }}>
          <View style={{ justifyContent: "center" }}>
            <Text variant="titleMedium">{draftOrder.price}</Text>
            {draftOrder.note && (
              <Text variant="labelSmall">{draftOrder.note}</Text>
            )}
            <Text variant="labelSmall">{formatDate(draftOrder.orderDate)}</Text>
          </View>
          <View style={{ justifyContent: "center" }}>
            <Text variant="titleMedium" style={{ color: theme.colors.primary }}>
              {draftOrder.subscriptionPlanType === OrderType.Buyout
                ? "永久"
                : "+" + rawTimeExtension2String(draftOrder.timeExtension)}
            </Text>
          </View>
        </View>
      </Card.Content>
    </Card>
  );
};
