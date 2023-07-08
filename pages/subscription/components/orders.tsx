import { Button, Text } from "react-native-paper";
import { OrderItem } from "./orderItem";
import { StyleProp, StyleSheet, View, ViewStyle } from "react-native";
import { DraftOrder, SubscriptionPlanType } from "../../../types";
import { AddOrderDialog } from "../../../components/addOrderDialog";
import { useMemo, useState } from "react";
import { OrdersModal } from "../../../modals";
import { Money } from "../../../util/money";

type BaseTypes = {
  isDraft?: boolean;
  onChange?: (orders: DraftOrder[]) => void;
  onAdd?: (order: DraftOrder) => void;
  containerStyle?: StyleProp<ViewStyle>;
  subscriptionPlanType: SubscriptionPlanType;
};

type DraftProps = BaseTypes & {
  isDraft: true;
  orders: DraftOrder[];
};

type NonDraftProps = BaseTypes & {
  isDraft?: false;
  orders: OrdersModal[];
};

type Props = DraftProps | NonDraftProps;

const defaultContainerStyle = {
  marginVertical: 8,
};

export const Orders = ({
  subscriptionPlanType,
  orders,
  onChange,
  onAdd,
  containerStyle,
}: Props) => {
  const [showDialog, setShowDialog] = useState(false);

  const totalCost = useMemo(() => {
    return Money.sum(...orders.map((order) => order.price)).toString();
  }, [orders]);

  const mergedStyles = StyleSheet.compose(
    defaultContainerStyle,
    containerStyle
  );

  const canDisplayAddOrderButton = () => {
    const isFirstBuyout =
      subscriptionPlanType === SubscriptionPlanType.Buyout &&
      orders.length === 0;

    return (
      isFirstBuyout || subscriptionPlanType !== SubscriptionPlanType.Buyout
    );
  };

  return (
    <View style={mergedStyles}>
      {!!orders.length && (
        <View
          style={{
            flexDirection: "row",
            justifyContent: "space-between",
            marginTop: 15,
            marginBottom: 10,
          }}
        >
          <Text variant="labelMedium">订单</Text>
          <Text variant="labelMedium">{totalCost}</Text>
        </View>
      )}
      {orders.map((order, index) => (
        <OrderItem key={index} draftOrder={order} />
      ))}
      {canDisplayAddOrderButton() && (
        <Button
          mode="contained-tonal"
          style={{ marginTop: 10 }}
          onPress={() => setShowDialog(true)}
        >
          添加订单
        </Button>
      )}
      <AddOrderDialog
        visible={showDialog}
        onCancel={() => setShowDialog(false)}
        onConfirm={(order) => {
          setShowDialog(false);
          if (onChange) onChange([...orders, order]);
          if (onAdd) onAdd(order);
        }}
        subscriptionPlanType={subscriptionPlanType}
      />
    </View>
  );
};
