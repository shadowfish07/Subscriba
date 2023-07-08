import { Text, TextInput, Button } from "react-native-paper";
import {
  DraftManualSubscriptionPlan,
  SubscriptionPlanType,
} from "../../../types";
import { globalStyles } from "../../../styles";
import { DraftPlanCard } from "./draftPlanCard";
import { useState } from "react";
import { getDefaultDraftSubscriptionPlan } from "../../../constants/draftSubscriptionPlan";
import { Orders } from "./orders";

type Props = {
  form?: DraftManualSubscriptionPlan;
  showSaveButton?: boolean;
  setFormKey?: <T extends keyof DraftManualSubscriptionPlan>(
    key: T,
    value: DraftManualSubscriptionPlan[T]
  ) => void;
  onCancel?: () => void;
  onSave?: (form: DraftManualSubscriptionPlan) => void;
};
export const DraftManualSubscriptionPlanCard = ({
  form,
  showSaveButton,
  setFormKey,
  onCancel,
  onSave,
}: Props) => {
  const [formState, setFormState] = useState(
    getDefaultDraftSubscriptionPlan(SubscriptionPlanType.Manual)
  );

  const setFormKeyState = <T extends keyof DraftManualSubscriptionPlan>(
    key: T,
    value: DraftManualSubscriptionPlan[T]
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
      title="手动订阅"
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
        subscriptionPlanType={SubscriptionPlanType.Manual}
      />
    </DraftPlanCard>
  );
};
