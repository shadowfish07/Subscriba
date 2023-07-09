import { Button, Dialog, Portal, RadioButton, Text } from "react-native-paper";
import { globalStyles } from "../../../styles";
import { useState } from "react";
import { OrderTypeLabel } from "../../../types";
import { View } from "react-native";

type Props = {
  onConfirm: (selectedPlan: OrderTypeLabel) => void;
};
export const AddSubscriptionDialog = ({ onConfirm }: Props) => {
  const [visible, setVisible] = useState(false);
  const [checked, setChecked] = useState<OrderTypeLabel | "">("");

  const showDialog = () => setVisible(true);
  const hideDialog = () => {
    setChecked("");
    setVisible(false);
  };
  const confirmDialog = () => {
    onConfirm(checked as OrderTypeLabel);
    hideDialog();
  };

  return (
    <>
      <Button style={globalStyles.card} mode="contained" onPress={showDialog}>
        新增手动订阅/连续包月/买断
      </Button>
      <Portal>
        <Dialog visible={visible} onDismiss={hideDialog}>
          <Dialog.Title>选择订阅类型</Dialog.Title>
          <Dialog.Content>
            <RadioButton.Group
              onValueChange={(newValue) =>
                setChecked(newValue as OrderTypeLabel)
              }
              value={checked}
            >
              <View style={{ flexDirection: "row", alignItems: "center" }}>
                <RadioButton value={OrderTypeLabel.Manual} />
                <Text>{OrderTypeLabel.Manual}</Text>
              </View>
              <View style={{ flexDirection: "row", alignItems: "center" }}>
                <RadioButton value={OrderTypeLabel.Auto} />
                <Text>{OrderTypeLabel.Auto}</Text>
              </View>
              <View style={{ flexDirection: "row", alignItems: "center" }}>
                <RadioButton value={OrderTypeLabel.Buyout} />
                <Text>{OrderTypeLabel.Buyout}</Text>
              </View>
            </RadioButton.Group>
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={hideDialog}>取消</Button>
            <Button disabled={checked === ""} onPress={confirmDialog}>
              确定
            </Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </>
  );
};
