import { useState } from "react";
import {
  Portal,
  Dialog,
  Button,
  Text,
  TextInput,
  SegmentedButtons,
  Checkbox,
} from "react-native-paper";
import { globalStyles } from "../styles";
import { MoneyInput } from "./moneyInput";
import { DatePickerInput } from "react-native-paper-dates";
import dayjs from "dayjs";
import { DraftOrder, OrderType } from "../types";
import { TimeExtensionInput } from "./timeExtensionInput";
import { View } from "react-native";

type Props = {
  visible: boolean;
  onConfirm: (draftOrder: DraftOrder) => void;
  onCancel: () => void;
};

export const AddOrderDialog = ({ visible, onCancel, onConfirm }: Props) => {
  const [price, setPrice] = useState("");
  const [activeDate, setActiveDate] = useState(dayjs().valueOf());
  const [orderType, setOrderType] = useState(OrderType.Manual);
  const [timeExtension, setTimeExtension] = useState("1m");

  const [includeInTheAverage, setIncludeInTheAverage] = useState(true);
  const [note, setNote] = useState("");

  const init = () => {
    setPrice("");
    setActiveDate(dayjs().valueOf());
    setOrderType(OrderType.Manual);
    setTimeExtension("1m");
    setNote("");
  };

  const handleCancel = () => {
    onCancel();
    init();
  };

  const handleConfirm = () => {
    onConfirm({
      price,
      note,
      orderDate: activeDate,
      timeExtension,
      type: orderType,
      discount: "",
      activeDate,
      includeInTheAverage,
    });
    handleCancel();
  };

  return (
    <Portal>
      <Dialog visible={visible} onDismiss={onCancel}>
        <Dialog.Title>新建订单</Dialog.Title>
        <Dialog.Content>
          <SegmentedButtons
            value={orderType.toString()}
            onValueChange={(value) => setOrderType(Number(value))}
            buttons={[
              {
                value: OrderType.Manual.toString(),
                label: "手动订阅",
              },
              {
                value: OrderType.Buyout.toString(),
                label: "买断",
              },
              // { value: OrderType.Auto.toString(), label: "连续包年" },
            ]}
            style={{ marginBottom: 5 }}
          />
          <MoneyInput label="金额" onChangeText={setPrice} value={price} />
          <DatePickerInput
            locale="zh"
            mode="outlined"
            label="生效时间"
            value={new Date(activeDate)}
            onChange={(value) => setActiveDate(dayjs(value).valueOf())}
            style={globalStyles.textInput}
            inputMode="start"
          />
          {orderType !== OrderType.Buyout && (
            <TimeExtensionInput
              value={timeExtension}
              onChangeText={setTimeExtension}
            />
          )}
          <TextInput
            label="备注"
            value={note}
            onChangeText={setNote}
            multiline
            mode="outlined"
            style={globalStyles.textInput}
          />
          {orderType !== OrderType.Buyout && (
            <View
              style={{
                flexDirection: "row",
                justifyContent: "space-between",
                alignItems: "center",
              }}
            >
              <Text>计入均值</Text>
              <Checkbox
                status={includeInTheAverage ? "checked" : "unchecked"}
                onPress={() => {
                  setIncludeInTheAverage(!includeInTheAverage);
                }}
              />
            </View>
          )}
        </Dialog.Content>
        <Dialog.Actions>
          <Button onPress={handleCancel}>取消</Button>
          <Button onPress={handleConfirm}>确定</Button>
        </Dialog.Actions>
      </Dialog>
    </Portal>
  );
};
