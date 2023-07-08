import { isString, isUndefined } from "lodash";
import { SupportedCurrency } from "../types";

export class Money {
  private currency: SupportedCurrency;
  private value: number;

  static fromCurrency(currency: SupportedCurrency, value: number) {
    return new Money(`${currency}${value}`);
  }

  static sum(...moneys: (Money | string)[]): Money {
    return moneys.reduce((a, b) => {
      const aMoney = a instanceof Money ? a : new Money(a);
      const bMoney = b instanceof Money ? b : new Money(b);
      return aMoney.add(bMoney);
    }, new Money()) as Money;
  }

  constructor(rawMoney: string = "¥0") {
    this.currency = rawMoney[0] as SupportedCurrency;
    this.value = Number(rawMoney.slice(1));
  }

  add(money: Money): Money {
    if (this.currency === money.currency) {
      return Money.fromCurrency(this.currency, this.value + money.value);
    }
  }

  divide(divisor: number): Money {
    return Money.fromCurrency(this.currency, this.value / divisor);
  }

  multiply(multiplier: number): Money {
    return Money.fromCurrency(this.currency, this.value * multiplier);
  }

  toString(decimalPlaces?: number): string {
    if (isUndefined(decimalPlaces)) {
      return `${this.currency}${this.value}`;
    }
    return `${this.currency}${
      Math.round(this.value * Math.pow(10, decimalPlaces)) /
      Math.pow(10, decimalPlaces)
    }`;
  }

  getValue(): number {
    return this.value;
  }

  compare(money: Money | string): number {
    const moneyInstance = money instanceof Money ? money : new Money(money);
    return this.value - moneyInstance.value;
  }
}
