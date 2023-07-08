import { useState } from "react";
import { Portal, Dialog, Button, Text, TextInput } from "react-native-paper";
import { globalStyles } from "../styles";
import { MoneyInput } from "./moneyInput";
import { DatePickerInput } from "react-native-paper-dates";
import dayjs from "dayjs";
import { DraftOrder } from "../types";
import { TimeExtensionInput } from "./timeExtensionInput";

type Props = {
  visible: boolean;
  onConfirm: (draftOrder: DraftOrder) => void;
  onCancel: () => void;
  isTimeExtensionForever?: boolean;
};

export const AddOrderDialog = ({
  visible,
  onCancel,
  onConfirm,
  isTimeExtensionForever,
}: Props) => {
  const [price, setPrice] = useState("");
  const [orderDate, setOrderDate] = useState(dayjs().valueOf());
  const [timeExtension, setTimeExtension] = useState(
    isTimeExtensionForever ? "-1d" : "1m"
  );
  const [note, setNote] = useState("");

  const init = () => {
    setPrice("");
    setOrderDate(dayjs().valueOf());
    setTimeExtension(isTimeExtensionForever ? "-1d" : "1m");
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
      orderDate,
      timeExtension,
    });
    onCancel();
  };

  return (
    <Portal>
      <Dialog visible={visible} onDismiss={onCancel}>
        <Dialog.Title>新建订单</Dialog.Title>
        <Dialog.Content>
          <MoneyInput label="金额" onChangeText={setPrice} value={price} />
          <DatePickerInput
            locale="zh"
            mode="outlined"
            label="订单时间"
            value={new Date(orderDate)}
            onChange={(value) => setOrderDate(dayjs(value).valueOf())}
            style={globalStyles.textInput}
            inputMode="start"
          />
          {!isTimeExtensionForever && (
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
        </Dialog.Content>
        <Dialog.Actions>
          <Button onPress={handleCancel}>取消</Button>
          <Button onPress={handleConfirm}>确定</Button>
        </Dialog.Actions>
      </Dialog>
    </Portal>
  );
};
