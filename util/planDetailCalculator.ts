import { sortBy } from "lodash";
import { OrdersModal } from "../modals";
import {
  BuyoutSubscriptionPlan,
  ManualSubscriptionPlan,
  SubscriptionPlanType,
} from "../types";
import { formatDate } from "./formatDate";
import { TimeExtension } from "./timeExtension";

export class PlanDetailCalculator {
  constructor(private plan: BuyoutSubscriptionPlan | ManualSubscriptionPlan) {}

  private get orders(): OrdersModal[] {
    return this.plan.orders;
  }

  get startTime(): string {
    return formatDate(sortBy(this.orders, ["orderDate"])[0].orderDate);
  }

  get endTime(): string {
    if (this.plan.type === SubscriptionPlanType.Buyout) {
      return "永久";
    }

    return formatDate(
      this.orders[this.orders.length - 1].orderDate +
        new TimeExtension(this.orders[this.orders.length - 1].timeExtension)
          .millisecond
    );
  }
}
