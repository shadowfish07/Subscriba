import { OrderType, PaymentCycle } from "./types";

export type BaseModal = {
  id: number;
  createdAt: number;
  updatedAt: number;
};

export type SubscriptionModal = BaseModal & {
  appName: string;
  note: string;
};

export type TagModal = BaseModal & {
  name: string;
  color: string;
};

type BaseOrdersModal = {
  serviceId: number;
  price: string;
  discount: string;
  note: string;
  /**
   * 订单时间（下单时间）
   */
  orderDate: number;
  /**
   * 生效时间
   * 每个订单的生效时间区间不能重叠
   */
  activeDate: number;
  /**
   * 订单增加的有效时间
   * 1d 目前都用这种格式存储
   */
  timeExtension: string;
  /**
   * 订单是否会被加入均值计算
   */
  includeInTheAverage: boolean;
};

type NonAutoSubscriptionModal = {
  type: OrderType.Buyout | OrderType.Manual;
};

type AutoSubscriptionModal = {
  type: OrderType.Auto;
  autoProtocolPrice: string;
  autoPaymentCycle: PaymentCycle;
};

export type OrdersModal = BaseModal &
  BaseOrdersModal &
  (NonAutoSubscriptionModal | AutoSubscriptionModal);

export type ServiceModal = BaseModal & {
  subscriptionId: number;
  name: string;
  note: string;
};
