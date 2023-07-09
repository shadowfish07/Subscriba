import { SubscriptionPlanType } from "./types";

/**
 * 由于 created的默认值设为number时间戳需要用触发器，
 * 目前 created/updated的时间格式为字符串，其他业务时间应使用number
 */

export type AutoSubscriptionPlanModal = {
  id: number;
  subscriptionId: number;
  serviceName: string;
  startAt: number;
  protocolPrice: number;
  paymentCycle: number;
  createdAt: string;
  updatedAt: string;
  /**
   * select计算值
   */
  type: SubscriptionPlanType.Auto;
};

export type BuyoutSubscriptionPlanModal = {
  id: number;
  subscriptionId: number;
  serviceName: string;
  createdAt: string;
  updatedAt: string;
  /**
   * select计算值
   */
  type: SubscriptionPlanType.Buyout;
};

export type ManualSubscriptionPlanModal = {
  id: number;
  subscriptionId: number;
  serviceName: string;
  createdAt: string;
  updatedAt: string;
  /**
   * select计算值
   */
  type: SubscriptionPlanType.Manual;
};

export type SubscriptionModal = {
  id: number;
  appName: string;
  note: string;
  createdAt: string;
  updatedAt: string;
};

export type TagModal = {
  id: number;
  name: string;
  color: string;
  createdAt: string;
  updatedAt: string;
};

export type OrdersModal = {
  id: number;
  subscriptionPlanId: number;
  subscriptionPlanType: SubscriptionPlanType;
  price: string;
  discount: string;
  note: string;
  /**
   * 生效时间
   * 每个订单的生效时间区间不能重叠
   */
  orderDate: number;
  /**
   * 订单增加的有效时间
   * 1d 目前都用这种格式存储
   */
  timeExtension: string;
  createdAt: string;
  updatedAt: string;
};
