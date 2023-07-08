import dayjs from "dayjs";
import {
  DraftAutoSubscriptionPlan,
  DraftBuyoutSubscriptionPlan,
  DraftManualSubscriptionPlan,
  DraftOrder,
  SubscriptionPlanType,
  SupportedDraftSubscriptionPlans,
} from "../types";

const DEFAULT_DRAFT_SUBSCRIPTION_PLAN = {
  [SubscriptionPlanType.Manual]: {
    type: SubscriptionPlanType.Manual,
    serviceName: "",
    orders: [],
  },
  [SubscriptionPlanType.Auto]: {
    type: SubscriptionPlanType.Auto,
    serviceName: "",
    startAt: dayjs().valueOf(),
    protocolPrice: "",
    paymentCycle: 0,
  },
  [SubscriptionPlanType.Buyout]: {
    type: SubscriptionPlanType.Buyout,
    serviceName: "",
    orders: [],
  },
};

type TransformType2Struct<T extends SubscriptionPlanType> =
  T extends SubscriptionPlanType.Manual
    ? DraftManualSubscriptionPlan
    : T extends SubscriptionPlanType.Buyout
    ? DraftBuyoutSubscriptionPlan
    : T extends SubscriptionPlanType.Auto
    ? DraftAutoSubscriptionPlan
    : never;

export const getDefaultDraftSubscriptionPlan = <T extends SubscriptionPlanType>(
  type: T
): TransformType2Struct<T> => {
  return DEFAULT_DRAFT_SUBSCRIPTION_PLAN[
    type
  ] as unknown as TransformType2Struct<T>;
};
