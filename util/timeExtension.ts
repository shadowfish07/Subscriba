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
      return this.unitValue * 24 * 60 * 60 * 1000;
    }
  }

  private get unit(): "d" {
    return "d";
    // const unit = this.rawValue.match(/d/);
    // return unit ? unit : "d";
  }
}
