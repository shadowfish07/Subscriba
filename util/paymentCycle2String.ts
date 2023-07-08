import { PaymentCycle } from "../types";

export function paymentCycle2String(cycle: PaymentCycle): string {
  switch (cycle) {
    case PaymentCycle.Monthly:
      return "月";
    case PaymentCycle.Yearly:
      return "年";
  }
}
