import { TextInput, Button, Text } from "react-native-paper";
import { DraftService, OrderType } from "../../../types";
import { globalStyles } from "../../../styles";
import { DraftCard } from "./draftCard";
import { useState } from "react";
import { Orders } from "./orders";
import { getDefaultDraftService } from "../../../constants/getDefaultDraftService";

type Props = {
  form?: DraftService;
  showSaveButton?: boolean;
  setFormKey?: <T extends keyof DraftService>(
    key: T,
    value: DraftService[T]
  ) => void;
  onCancel?: () => void;
  onSave?: (form: DraftService) => void;
};
export const DraftServiceCard = ({
  form,
  showSaveButton,
  setFormKey,
  onCancel,
  onSave,
}: Props) => {
  const [formState, setFormState] = useState(getDefaultDraftService());

  const setFormKeyState = <T extends keyof DraftService>(
    key: T,
    value: DraftService[T]
  ) => {
    setFormState({
      ...formState,
      [key]: value,
    });
  };

  const usingForm = form || formState;
  const usingSetFormKey = setFormKey || setFormKeyState;

  return (
    <DraftCard
      onCancel={onCancel}
      onSave={() => onSave(usingForm)}
      showSaveButton={showSaveButton}
    >
      <TextInput
        label="订阅服务名称"
        mode="outlined"
        value={usingForm.name}
        onChangeText={(value) => usingSetFormKey("name", value)}
        style={globalStyles.textInput}
      />
      <TextInput
        label="备注"
        mode="outlined"
        value={usingForm.note}
        onChangeText={(value) => usingSetFormKey("note", value)}
        style={globalStyles.textInput}
      />
      <Orders
        isDraft={true}
        orders={usingForm.orders}
        onChange={(orders) => usingSetFormKey("orders", orders)}
      />
    </DraftCard>
  );
};
