import { Button, Dialog, Portal, Text, useTheme } from "react-native-paper";
import { OrderItem } from "./orderItem";
import { StyleProp, StyleSheet, View, ViewStyle } from "react-native";
import { DraftOrder, OrderType } from "../../../types";
import { AddOrderDialog } from "../../../components/addOrderDialog";
import { useMemo, useRef, useState } from "react";
import { OrdersModal } from "../../../modals";
import { Money } from "../../../util/money";
import { useDatabase } from "../../../hooks/useDatabase";

type BaseTypes = {
  serviceId: number | null;
  isDraft?: boolean;
  onChange?: (orders: DraftOrder[]) => void;
  onAdd?: (order: DraftOrder) => void;
  containerStyle?: StyleProp<ViewStyle>;
};

type DraftProps = BaseTypes & {
  isDraft: true;
  orders: DraftOrder[];
  onDelete: never;
};

type NonDraftProps = BaseTypes & {
  isDraft?: false;
  orders: OrdersModal[];
  onDelete: (id: number) => void;
};

type Props = DraftProps | NonDraftProps;

const defaultContainerStyle = {
  marginVertical: 8,
};

export const Orders = ({
  orders,
  onChange,
  onAdd,
  onDelete,
  containerStyle,
  serviceId,
}: Props) => {
  const [showDialog, setShowDialog] = useState(false);
  const [deleteVisible, setDeleteVisible] = useState(false);

  const showDeleteDialog = () => setDeleteVisible(true);
  const hideDeleteDialog = () => setDeleteVisible(false);

  const theme = useTheme();

  const totalCost = useMemo(() => {
    return Money.sum(...orders.map((order) => order.price)).toString();
  }, [orders]);

  const mergedStyles = StyleSheet.compose(
    defaultContainerStyle,
    containerStyle
  );

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
      <Button
        mode="contained-tonal"
        style={{ marginTop: 10, marginBottom: -20 }}
        onPress={() => setShowDialog(true)}
      >
        添加订单
      </Button>
      {serviceId !== null && (
        <Button
          style={{ marginTop: 20 }}
          textColor={theme.colors.error}
          onPress={() => {
            showDeleteDialog();
          }}
        >
          删除服务
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
      />
      <Portal>
        <Dialog visible={deleteVisible} onDismiss={hideDeleteDialog}>
          <Dialog.Title>确认删除</Dialog.Title>
          <Dialog.Content>
            <Text>确定删除订单吗？该操作不可撤销！</Text>
          </Dialog.Content>
          <Dialog.Actions>
            <Button
              onPress={() => {
                onDelete(serviceId);
                hideDeleteDialog();
              }}
            >
              <Text style={{ color: theme.colors.error }}>删除</Text>
            </Button>
            <Button onPress={hideDeleteDialog}>取消</Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </View>
  );
};
