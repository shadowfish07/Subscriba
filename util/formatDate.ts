import dayjs from "dayjs";

export function formatDate(date: string | number) {
  return dayjs(date).format("YYYY/MM/DD");
}
