import { SQLResultSetRowList } from "expo-sqlite";
import {
  IDraftSubscription,
  useDraftSubscriptionStore,
} from "../store/useDraftSubscriptionStore";
import { useDatabase } from "./useDatabase";

type Return = {
  saveSubscription: () => Promise<void>;
} & IDraftSubscription;

export function useDraftSubscription(): Return {
  const draftSubscriptionStore = useDraftSubscriptionStore();

  const { databaseService } = useDatabase();

  const saveSubscription = async (): Promise<void> => {
    await databaseService.createSubscription(
      draftSubscriptionStore.draftSubscription
    );
  };

  return {
    ...draftSubscriptionStore,
    saveSubscription,
  };
}
