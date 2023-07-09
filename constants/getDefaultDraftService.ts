import { DraftService } from "../types";

export const getDefaultDraftService = (): DraftService => {
  return {
    name: "",
    note: "",
    orders: [],
  };
};
