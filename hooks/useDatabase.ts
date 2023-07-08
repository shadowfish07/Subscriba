import { useEffect, useRef, useState } from "react";
import { useDatabaseStore } from "../store/useDatabaseStore";
import { DatabaseService } from "../util/databaseService";

type Return = {
  databaseService: DatabaseService | null;
};

export function useDatabase(): Return {
  const { db } = useDatabaseStore((store) => ({
    db: store.database,
  }));
  const [databaseService, setDatabaseService] =
    useState<DatabaseService | null>(null);

  useEffect(() => {
    setDatabaseService(db ? new DatabaseService(db) : null);
  }, [db]);

  return {
    databaseService,
  };
}
