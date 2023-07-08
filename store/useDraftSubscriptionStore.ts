import { create } from "zustand";
import {
  DraftSubscription,
  SubscriptionPlanType,
  SupportedDraftSubscriptionPlans,
} from "../types";
import dayjs from "dayjs";
import { getDefaultDraftSubscriptionPlan } from "../constants/draftSubscriptionPlan";
export interface IDraftSubscription {
  draftSubscription: DraftSubscription;
  setBasicInfoKey: <T extends keyof DraftSubscription["basicInfo"]>(
    key: T,
    value: DraftSubscription["basicInfo"][T]
  ) => void;
  setSubscriptionPlanKey: (index: number, key: string, value: any) => void;
  setDraftSubscription: (draftSubscription: DraftSubscription) => void;
  addSubscriptionPlan: (type: SubscriptionPlanType) => void;
  deleteSubscriptionPlan: (index: number) => void;
}

export const useDraftSubscriptionStore = create<IDraftSubscription>(
  (set, get) => ({
    draftSubscription: {
      basicInfo: {
        appName: "",
        note: "",
      },
      subscriptionPlans: [],
    },
    setDraftSubscription: (draftSubscription) => set({ draftSubscription }),
    setBasicInfoKey: <T extends keyof DraftSubscription["basicInfo"]>(
      key: T,
      value: DraftSubscription["basicInfo"][T]
    ) => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            basicInfo: {
              ...draft.draftSubscription.basicInfo,
              [key]: value,
            },
          },
        };
      });
    },
    addSubscriptionPlan: (type: SubscriptionPlanType) => {
      set((draft) => {
        function getNewSubscriptionPlan(
          type: SubscriptionPlanType
        ): SupportedDraftSubscriptionPlans {
          return getDefaultDraftSubscriptionPlan(type);
        }
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            subscriptionPlans: [
              ...draft.draftSubscription.subscriptionPlans,
              getNewSubscriptionPlan(type),
            ],
          },
        };
      });
    },
    setSubscriptionPlanKey: (index: number, key: string, value: any) => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            subscriptionPlans: [
              ...draft.draftSubscription.subscriptionPlans.slice(0, index),
              {
                ...draft.draftSubscription.subscriptionPlans[index],
                [key]: value,
              },
              ...draft.draftSubscription.subscriptionPlans.slice(index + 1),
            ],
          },
        };
      });
    },
    deleteSubscriptionPlan: (index: number) => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            subscriptionPlans: [
              ...draft.draftSubscription.subscriptionPlans.slice(0, index),
              ...draft.draftSubscription.subscriptionPlans.slice(index + 1),
            ],
          },
        };
      });
    },
  })
);
