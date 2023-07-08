export function rawTimeExtension2String(value: string) {
  if (value[value.length - 1] === "d") {
    return value.slice(0, value.length - 1) + "日";
  } else if (value[value.length - 1] === "m") {
    return value.slice(0, value.length - 1) + "月";
  } else {
    return value.slice(0, value.length - 1) + "年";
  }
}
