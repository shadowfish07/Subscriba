import { create } from "zustand";
import { DraftSubscription } from "../types";
import { getDefaultDraftService } from "../constants/getDefaultDraftService";
export interface IDraftSubscription {
  draftSubscription: DraftSubscription;
  setBasicInfoKey: <T extends keyof DraftSubscription["basicInfo"]>(
    key: T,
    value: DraftSubscription["basicInfo"][T]
  ) => void;
  setServiceKey: (index: number, key: string, value: any) => void;
  addService: () => void;
  deleteService: (index: number) => void;
  init: () => void;
}

export const useDraftSubscriptionStore = create<IDraftSubscription>(
  (set, get) => ({
    draftSubscription: {
      basicInfo: {
        appName: "",
        note: "",
      },
      services: [getDefaultDraftService()],
    },
    init: () => {
      set((draft) => {
        return {
          draftSubscription: {
            basicInfo: {
              appName: "",
              note: "",
            },
            services: [getDefaultDraftService()],
          },
        };
      });
    },
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
    addService: () => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            services: [
              ...draft.draftSubscription.services,
              getDefaultDraftService(),
            ],
          },
        };
      });
    },
    setServiceKey: (index: number, key: string, value: any) => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            services: [
              ...draft.draftSubscription.services.slice(0, index),
              {
                ...draft.draftSubscription.services[index],
                [key]: value,
              },
              ...draft.draftSubscription.services.slice(index + 1),
            ],
          },
        };
      });
    },
    deleteService: (index: number) => {
      set((draft) => {
        return {
          draftSubscription: {
            ...draft.draftSubscription,
            services: [
              ...draft.draftSubscription.services.slice(0, index),
              ...draft.draftSubscription.services.slice(index + 1),
            ],
          },
        };
      });
    },
  })
);
