import { AVERAGE_DAYS_PER_MONTH } from "../constants";

export class TimeExtension {
  constructor(private rawValue: string) {
    // TODO 在这里做校验
  }

  get unitValue(): number {
    const number = this.rawValue.match(/\d+/);
    return number ? parseInt(number[0]) : 0;
  }

  get millisecond(): number {
    if (this.unit === "d") {
      return this.days * 24 * 60 * 60 * 1000;
    }

    if (this.unit === "m") {
      return this.days * 24 * 60 * 60 * 1000;
    }

    if (this.unit === "y") {
      return this.days * 24 * 60 * 60 * 1000;
    }
  }

  get days(): number {
    if (this.unit === "d") {
      return this.unitValue;
    }

    if (this.unit === "m") {
      return this.unitValue * AVERAGE_DAYS_PER_MONTH;
    }

    if (this.unit === "y") {
      return this.unitValue * 365;
    }
  }

  get unit(): "d" | "m" | "y" {
    const unit = this.rawValue.match(/[dmy]/);
    return unit ? (unit[0] as "y" | "m" | "d") : "d";
  }
}
