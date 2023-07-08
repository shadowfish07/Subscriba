import {
  AutoSubscriptionPlanModal,
  BuyoutSubscriptionPlanModal,
  ManualSubscriptionPlanModal,
  OrdersModal,
  SubscriptionModal,
} from "./modals";

export enum SubscriptionPlanTypeLabel {
  Manual = "手动订阅",
  Auto = "连续包月",
  Buyout = "买断",
}
export enum SubscriptionPlanType {
  Manual = 0,
  Auto = 1,
  Buyout = 2,
}

export enum PaymentCycle {
  Monthly = 0,
  Yearly = 1,
}

export type Subscription = {
  id: number;
  appName: string;
  note: string;
  orders: OrdersModal[];
  createdAt: string;
  updatedAt: string;
};

export enum SupportedCurrency {
  CNY = "¥",
}

export type Tag = {
  id: number;
  name: string;
  color: string;
  createdAt: string;
  updatedAt: string;
};

export type RouteParams = {
  SubscriptionDetail: {
    id: number;
    appName: string;
  };
};

export type PriceInfoOfSubscriptionPlan = {
  orders: OrdersModal[];
  totalPrice: string;
};

export type BuyoutSubscriptionPlan = BuyoutSubscriptionPlanModal &
  PriceInfoOfSubscriptionPlan;

export type ManualSubscriptionPlan = ManualSubscriptionPlanModal &
  PriceInfoOfSubscriptionPlan;

export type SubscriptionDetail = {
  basicInfo: SubscriptionModal;
  subscriptionPlans: (
    | AutoSubscriptionPlanModal
    | BuyoutSubscriptionPlan
    | ManualSubscriptionPlan
  )[];
};

// ====Draft=====

export type DraftOrder = {
  price: string;
  note?: string;
  orderDate: number;
  timeExtension: string;
  subscriptionPlanType: SubscriptionPlanType;
};

export type DraftManualSubscriptionPlan = {
  type: SubscriptionPlanType.Manual;
  serviceName: string;
  orders: DraftOrder[];
};

export type DraftAutoSubscriptionPlan = {
  type: SubscriptionPlanType.Auto;
  serviceName: string;
  startAt: number;
  protocolPrice: string;
  paymentCycle: PaymentCycle;
};

export type DraftBuyoutSubscriptionPlan = {
  type: SubscriptionPlanType.Buyout;
  serviceName: string;
  orders: DraftOrder[];
};

export type SupportedDraftSubscriptionPlans =
  | DraftAutoSubscriptionPlan
  | DraftBuyoutSubscriptionPlan
  | DraftManualSubscriptionPlan;

export type DraftSubscription = {
  basicInfo: {
    appName: string;
    note: string;
  };
  subscriptionPlans: SupportedDraftSubscriptionPlans[];
};
