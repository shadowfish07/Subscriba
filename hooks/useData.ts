import { useCallback, useState } from "react";
import { DatabaseService } from "../util/databaseService";
import { useDatabase } from "./useDatabase";
import { useFocusEffect } from "@react-navigation/native";

type Return<T> = {
  data: T;
  load: () => Promise<void>;
};

export function useData<API extends keyof DatabaseService>(
  api: API,
  args: Parameters<DatabaseService[API]>
): Return<Awaited<ReturnType<DatabaseService[API]>>> {
  const { databaseService } = useDatabase();
  const [data, setData] = useState(null);

  const load = async () => {
    if (!databaseService) return;
    try {
      const result = await databaseService[api].call(databaseService, ...args);
      setData(result);
    } catch (error) {
      console.log(error);
    }
  };

  useFocusEffect(
    useCallback(() => {
      load();
    }, [databaseService])
  );

  return { data, load };
}
