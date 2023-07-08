import { create } from "zustand";

export interface PerUnit {
  unit: "日均" | "月均" | "年均";
  setUnit: (unit: "日均" | "月均" | "年均") => void;
}

export const usePerUnitStore = create<PerUnit>((set, get) => ({
  unit: "年均",
  setUnit: (unit) => set({ unit }),
}));
