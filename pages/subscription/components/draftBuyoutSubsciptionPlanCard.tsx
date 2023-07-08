import { TextInput, Button, Text } from "react-native-paper";
import {
  DraftBuyoutSubscriptionPlan,
  SubscriptionPlanType,
} from "../../../types";
import { globalStyles } from "../../../styles";
import { DraftPlanCard } from "./draftPlanCard";
import { useState } from "react";
import { getDefaultDraftSubscriptionPlan } from "../../../constants/draftSubscriptionPlan";
import { Orders } from "./orders";

type Props = {
  form?: DraftBuyoutSubscriptionPlan;
  showSaveButton?: boolean;
  setFormKey?: <T extends keyof DraftBuyoutSubscriptionPlan>(
    key: T,
    value: DraftBuyoutSubscriptionPlan[T]
  ) => void;
  onCancel?: () => void;
  onSave?: (form: DraftBuyoutSubscriptionPlan) => void;
};
export const DraftBuyoutSubscriptionPlanCard = ({
  form,
  showSaveButton,
  setFormKey,
  onCancel,
  onSave,
}: Props) => {
  const [formState, setFormState] = useState(
    getDefaultDraftSubscriptionPlan(SubscriptionPlanType.Buyout)
  );

  const setFormKeyState = <T extends keyof DraftBuyoutSubscriptionPlan>(
    key: T,
    value: DraftBuyoutSubscriptionPlan[T]
  ) => {
    setFormState({
      ...formState,
      [key]: value,
    });
  };

  const usingForm = form || formState;
  const usingSetFormKey = setFormKey || setFormKeyState;

  return (
    <DraftPlanCard
      title="买断"
      onCancel={onCancel}
      onSave={() => onSave(usingForm)}
      showSaveButton={showSaveButton}
    >
      <TextInput
        label="订阅服务名称"
        mode="outlined"
        value={usingForm.serviceName}
        onChangeText={(value) => usingSetFormKey("serviceName", value)}
        style={globalStyles.textInput}
      />
      <Orders
        isDraft={true}
        orders={usingForm.orders}
        onChange={(orders) => usingSetFormKey("orders", orders)}
        subscriptionPlanType={SubscriptionPlanType.Buyout}
      />
    </DraftPlanCard>
  );
};
