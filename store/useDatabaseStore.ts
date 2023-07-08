import { create } from "zustand";
import * as SQLite from "expo-sqlite";
import { DROP_ALL_TABLES, TABLE_SCHEMAS } from "./databaseSchema";

interface IDatabase {
  database: SQLite.WebSQLDatabase;
  openDatabase: () => void;
}

function sqlSchemaToExec(sqlSchemas: string[]) {
  return sqlSchemas.map((schema) => {
    return {
      sql: schema,
      args: [],
    };
  });
}

function initDatabase(database: SQLite.WebSQLDatabase) {
  database.exec(
    [
      {
        sql: 'SELECT name FROM sqlite_master WHERE type="table" AND name="subscription"',
        args: [],
      },
    ],
    false,
    (err, res) => {
      if ((res[0] as any).rows.length === 0) {
        database.exec(
          sqlSchemaToExec(DROP_ALL_TABLES).concat(
            sqlSchemaToExec(TABLE_SCHEMAS)
          ),
          false,
          (err, res) => {}
        );
      }
    }
  );
}

export const useDatabaseStore = create<IDatabase>((set, get) => ({
  database: null,
  openDatabase: () => {
    const database = SQLite.openDatabase("db.db");
    set({ database });
    initDatabase(database);
  },
}));
