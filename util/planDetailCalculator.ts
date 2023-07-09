import { sortBy } from "lodash";
import { OrdersModal } from "../modals";
import { OrderType, Service } from "../types";
import { formatDate } from "./formatDate";
import { TimeExtension } from "./timeExtension";

export class PlanDetailCalculator {
  constructor(private service: Service) {}

  private get orders(): OrdersModal[] {
    return this.service.orders;
  }

  get startTime(): string {
    if (this.service.orders.length === 0) {
      return "-";
    }
    return formatDate(sortBy(this.orders, ["orderDate"])[0].orderDate);
  }

  get endTime(): string {
    if (this.service.orders.length === 0) {
      return "-";
    }

    if (this.service.orders.some((order) => order.type === OrderType.Buyout)) {
      return "永久";
    }

    return formatDate(
      this.orders[this.orders.length - 1].orderDate +
        new TimeExtension(this.orders[this.orders.length - 1].timeExtension)
          .millisecond
    );
  }
}
