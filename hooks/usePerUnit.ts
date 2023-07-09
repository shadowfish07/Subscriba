import { useCallback } from "react";
import { usePerUnitStore } from "../store/usePerUnitStore";
import { Money } from "../util/money";
import { OrdersModal } from "../modals";
import dayjs from "dayjs";
import { min } from "lodash";
import { OrderType, Service } from "../types";
import { OrderCalculator } from "../util/orderCalculator";

type ReturnType = {
  unit: "日均" | "月均" | "年均";
  setUnit: (unit: "日均" | "月均" | "年均") => void;
  calculateOrdersPerCost: (orders: OrdersModal[]) => string;
  calculateServicesPerCost: (services: Service[]) => string;
  calculateBuyoutCost: (orders: OrdersModal[]) => string;
};

export function usePerUnit(): ReturnType {
  const { unit, setUnit } = usePerUnitStore();

  const calculateOrdersPerCost = (orders: OrdersModal[]) => {
    return new OrderCalculator(orders).getPerCost(unit);
  };

  const calculateServicesPerCost = (services: Service[]) => {
    console.log(
      "🚀 ~ file: usePerUnit.ts:26 ~ calculateServicesPerCost ~ services:",
      JSON.stringify(services)
    );
    return services
      .reduce((prev, curr) => {
        return prev.add(new Money(calculateOrdersPerCost(curr.orders)));
      }, new Money())
      .toString(2);
  };

  const calculateBuyoutCost = (orders: OrdersModal[]) => {
    return orders
      .filter((order) => order.type === OrderType.Buyout)
      .reduce((prev, curr) => {
        const currentMoney = new Money(curr.price);
        return currentMoney.add(prev);
      }, new Money())
      .toString(0);
  };

  return {
    unit,
    setUnit,
    calculateOrdersPerCost,
    calculateBuyoutCost,
    calculateServicesPerCost,
  };
}
