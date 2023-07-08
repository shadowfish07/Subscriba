import { useCallback } from "react";
import { usePerUnitStore } from "../store/usePerUnitStore";
import { Money } from "../util/money";
import { OrdersModal } from "../modals";
import dayjs from "dayjs";
import { min } from "lodash";
import { SubscriptionPlanType } from "../types";

type ReturnType = {
  unit: "日均" | "月均" | "年均";
  setUnit: (unit: "日均" | "月均" | "年均") => void;
  calculatePerCost: (orders: OrdersModal[]) => string;
  calculateBuyoutCost: (orders: OrdersModal[]) => string;
};

export function usePerUnit(): ReturnType {
  const { unit, setUnit } = usePerUnitStore();

  const calculatePerCost = useCallback(
    (orders: OrdersModal[]) => {
      function calculateNonBuyout() {
        const nonBuyoutOrders = orders.filter(
          (order) => order.timeExtension != "-1d"
        );
        const priceSum = nonBuyoutOrders.reduce((prev, curr) => {
          const currentMoney = new Money(curr.price);
          return currentMoney.add(prev);
        }, new Money("¥0"));
        const activeDay = nonBuyoutOrders.reduce((prev, curr) => {
          return (
            prev +
            Number(curr.timeExtension.slice(0, curr.timeExtension.length - 1))
          );
        }, 0);
        const perDay =
          activeDay === 0 ? new Money("¥0") : priceSum.divide(activeDay);

        switch (unit) {
          case "日均":
            return perDay;
          case "月均":
            return perDay.multiply(30);
          case "年均":
            return perDay.multiply(365);
        }
      }

      /**
       * 买断的会计算买断总额除以已使用天数，转换到月均/年均时不会超过原价
       * 目前不计入均价计算
       */
      function calculateBuyout() {
        const buyoutOrders = orders.filter(
          (order) => order.timeExtension == "-1d"
        );
        const priceSum = buyoutOrders.reduce((prev, curr) => {
          const currentMoney = new Money(curr.price);
          const activeDay = dayjs().diff(dayjs(curr.orderDate), "day");
          const perDay =
            activeDay === 0 ? new Money("¥0") : currentMoney.divide(activeDay);

          switch (unit) {
            case "日均":
              return perDay.add(prev);
            case "月均":
              return min([perDay.add(prev).multiply(30), perDay.add(prev)]);
            case "年均":
              return min([perDay.add(prev).multiply(365), perDay.add(prev)]);
          }
        }, new Money("¥0"));

        return priceSum;
      }

      return calculateNonBuyout().toString(0);
    },
    [unit]
  );

  const calculateBuyoutCost = useCallback(
    (orders: OrdersModal[]) => {
      return orders
        .filter(
          (order) => order.subscriptionPlanType === SubscriptionPlanType.Buyout
        )
        .reduce((prev, curr) => {
          const currentMoney = new Money(curr.price);
          return currentMoney.add(prev);
        }, new Money())
        .toString(0);
    },
    [unit]
  );

  return { unit, setUnit, calculatePerCost, calculateBuyoutCost };
}
