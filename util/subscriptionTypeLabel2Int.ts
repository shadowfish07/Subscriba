import { SubscriptionPlanType, SubscriptionPlanTypeLabel } from "../types";

export const subscriptionTypeLabel2Int = (
  label: SubscriptionPlanTypeLabel
): SubscriptionPlanType => {
  switch (label) {
    case SubscriptionPlanTypeLabel.Manual:
      return 0;
    case SubscriptionPlanTypeLabel.Auto:
      return 1;
    case SubscriptionPlanTypeLabel.Buyout:
      return 2;
  }
};
