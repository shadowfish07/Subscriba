import { min, sortBy } from "lodash";
import { OrdersModal } from "../modals";
import { OrderType } from "../types";
import { formatDate } from "./formatDate";
import { TimeExtension } from "./timeExtension";
import { Money } from "./money";
import dayjs from "dayjs";
import { PER_UNIT_MAP, PER_UNIT_MULTIPLIER_MAP } from "../constants/perUnitMap";

export class OrderCalculator {
  constructor(private orders: OrdersModal[]) {}

  get startTime(): string {
    if (this.orders.length === 0) {
      return "-";
    }
    return formatDate(sortBy(this.orders, ["orderDate"])[0].orderDate);
  }

  get endTime(): string {
    if (this.orders.length === 0) {
      return "-";
    }

    if (this.orders.some((order) => order.type === OrderType.Buyout)) {
      return "永久";
    }

    return formatDate(
      this.orders[this.orders.length - 1].orderDate +
        new TimeExtension(this.orders[this.orders.length - 1].timeExtension)
          .millisecond
    );
  }

  getPerCost(unit: "日均" | "月均" | "年均"): string {
    if (this.orders.length === 0) {
      return new Money().toString(2);
    }
    /**
     * 如果单位相同，直接返回原值
     * 如果单位不同，换算成日均后计算
     */
    const calculateOrderPerCost = (order: OrdersModal) => {
      if (new TimeExtension(order.timeExtension).unit === PER_UNIT_MAP[unit]) {
        return new Money(order.price);
      }

      const perDayCost = new Money(order.price).divide(
        new TimeExtension(order.timeExtension).days
      );

      return perDayCost.multiply(PER_UNIT_MULTIPLIER_MAP[unit]);
    };

    const calculateNonBuyout = () => {
      return this.orders
        .filter(
          (order) =>
            order.type !== OrderType.Buyout && order.includeInTheAverage
        )
        .reduce((prev, curr) => {
          return prev.add(calculateOrderPerCost(curr));
        }, new Money())
        .divide(this.orders.length);
    };

    return calculateNonBuyout().toString(2);
  }
}
