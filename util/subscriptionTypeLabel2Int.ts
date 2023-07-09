import { OrderType, OrderTypeLabel } from "../types";

export const subscriptionTypeLabel2Int = (label: OrderTypeLabel): OrderType => {
  switch (label) {
    case OrderTypeLabel.Manual:
      return 0;
    case OrderTypeLabel.Auto:
      return 1;
    case OrderTypeLabel.Buyout:
      return 2;
  }
};
