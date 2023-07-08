import dayjs from "dayjs";
import { SegmentedButtons, TextInput, Text } from "react-native-paper";
import { DatePickerInput } from "react-native-paper-dates";
import {
  PaymentCycle,
  DraftAutoSubscriptionPlan,
  SubscriptionPlanType,
} from "../../../types";
import { globalStyles } from "../../../styles";
import { DraftPlanCard } from "./draftPlanCard";
import { useState } from "react";
import { getDefaultDraftSubscriptionPlan } from "../../../constants/draftSubscriptionPlan";
import { MoneyInput } from "../../../components/moneyInput";

type Props = {
  form?: DraftAutoSubscriptionPlan;
  showSaveButton?: boolean;
  setFormKey?: <T extends keyof DraftAutoSubscriptionPlan>(
    key: T,
    value: DraftAutoSubscriptionPlan[T]
  ) => void;
  onCancel?: () => void;
  onSave?: (form: DraftAutoSubscriptionPlan) => void;
};
export const DraftAutoSubscriptionPlanCard = ({
  form,
  showSaveButton,
  setFormKey,
  onCancel,
  onSave,
}: Props) => {
  const [formState, setFormState] = useState(
    getDefaultDraftSubscriptionPlan(SubscriptionPlanType.Auto)
  );

  const setFormKeyState = <T extends keyof DraftAutoSubscriptionPlan>(
    key: T,
    value: DraftAutoSubscriptionPlan[T]
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
      title="连续包月/年"
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
      <DatePickerInput
        locale="zh"
        mode="outlined"
        label="开始时间"
        value={new Date(usingForm.startAt)}
        onChange={(value) => usingSetFormKey("startAt", dayjs(value).valueOf())}
        style={globalStyles.textInput}
        inputMode="start"
      />
      <MoneyInput
        label="协议价格"
        onChangeText={(value) => usingSetFormKey("protocolPrice", value)}
        value={usingForm.protocolPrice}
      />

      <Text variant="labelMedium" style={{ marginTop: 15, marginBottom: 10 }}>
        付款周期
      </Text>
      <SegmentedButtons
        value={usingForm.paymentCycle.toString()}
        onValueChange={(value) =>
          usingSetFormKey("paymentCycle", Number(value))
        }
        buttons={[
          {
            value: PaymentCycle.Yearly.toString(),
            label: "年付",
          },
          {
            value: PaymentCycle.Monthly.toString(),
            label: "月付",
          },
        ]}
      />
    </DraftPlanCard>
  );
};
