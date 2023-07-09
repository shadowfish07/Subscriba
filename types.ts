import {
  BaseModal,
  OrdersModal,
  ServiceModal,
  SubscriptionModal,
} from "./modals";

export enum OrderTypeLabel {
  Manual = "手动订阅",
  Auto = "连续包月",
  Buyout = "买断",
}
export enum OrderType {
  Manual = 0,
  Auto = 1,
  Buyout = 2,
}

export enum PaymentCycle {
  Monthly = 0,
  Yearly = 1,
}

export type Subscription = SubscriptionModal & {
  orders: OrdersModal[];
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

export type Service = ServiceModal & { orders: OrdersModal[] };

export type SubscriptionDetail = {
  basicInfo: SubscriptionModal;
  services: Service[];
};

export type Draft<T extends BaseModal> = Omit<T, keyof BaseModal>;
export type DraftService = Omit<Draft<ServiceModal>, "subscriptionId"> & {
  orders: DraftOrder[];
};
export type DraftOrder = Omit<Draft<OrdersModal>, "serviceId">;

export type DraftSubscription = {
  basicInfo: Draft<SubscriptionModal>;
  services: DraftService[];
};
