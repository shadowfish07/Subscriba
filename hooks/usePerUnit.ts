import { useCallback, useState } from "react";
import { PerUnit, usePerUnitStore } from "../store/usePerUnitStore";
import { Money } from "../util/money";
import { OrdersModal } from "../modals";
import dayjs from "dayjs";
import { min } from "lodash";
import { OrderType, Service } from "../types";
import { OrderCalculator } from "../util/orderCalculator";

type ReturnType = {
  unit: "日均" | "月均" | "年均";
  setUnit: (unit: "日均" | "月均" | "年均") => void;
  setNextUnit: () => void;
  calculateOrdersPerCost: (orders: OrdersModal[]) => string;
  calculateServicesPerCost: (services: Service[]) => string;
  calculateBuyoutCost: (orders: OrdersModal[]) => string;
};

export function usePerUnit(usingGlobalData: boolean = false): ReturnType {
  const storageSource: () => [PerUnit["unit"], PerUnit["setUnit"]] =
    usingGlobalData
      ? () => usePerUnitStore((store) => [store.unit, store.setUnit])
      : () => useState<PerUnit["unit"]>("月均");
  const [unit, setUnit] = storageSource();

  const setNextUnit = () => {
    if (unit === "年均") {
      setUnit("月均");
    } else if (unit === "月均") {
      setUnit("日均");
    } else {
      setUnit("年均");
    }
  };

  const calculateOrdersPerCost = (orders: OrdersModal[]) => {
    return new OrderCalculator(orders).getPerCost(unit);
  };

  const calculateServicesPerCost = (services: Service[]) => {
    return services
      .reduce((prev, curr) => {
        return prev.add(new Money(calculateOrdersPerCost(curr.orders)));
      }, new Money())
      .toString(2);
  };

  const calculateBuyoutCost = (orders: OrdersModal[]) => {
    return new OrderCalculator(orders).totalBuyoutCost;
  };

  return {
    unit,
    setUnit,
    setNextUnit,
    calculateOrdersPerCost,
    calculateBuyoutCost,
    calculateServicesPerCost,
  };
}
