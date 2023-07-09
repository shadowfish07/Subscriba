export const DROP_ALL_TABLES = [
  `
    DROP TABLE IF EXISTS auto_subscription_plan;`,
  `
    DROP TABLE IF EXISTS buyout_subscription_plan;`,
  `
    DROP TABLE IF EXISTS manual_subscription_plan;`,
  `
    DROP TABLE IF EXISTS subscription;`,
  `
    DROP TABLE IF EXISTS tag;`,
  `
    DROP TABLE IF EXISTS orders;`,
  `
    DROP TABLE IF EXISTS service;`,
];

const generateTable = (tableName: string, columns: string) => {
  return [
    `
create table ${tableName}
(
    id                 INTEGER
        constraint ${tableName}_pk
            primary key autoincrement,
    ${columns}
    createdAt INTEGER,
    updatedAt INTEGER
);
    `,
    ...generateCreatedAtAndUpdatedAtTrigger(tableName),
  ];
};

const generateCreatedAtAndUpdatedAtTrigger = (tableName: string) => {
  return [
    `
    CREATE TRIGGER ${tableName}_set_createdAt
    AFTER INSERT ON ${tableName}
    FOR EACH ROW
    BEGIN
        UPDATE ${tableName} SET createdAt = strftime('%s', 'now') WHERE id = NEW.id;
    END;
    `,
    `
    CREATE TRIGGER ${tableName}_set_updatedAt
    AFTER UPDATE ON ${tableName}
    FOR EACH ROW
    BEGIN
        UPDATE ${tableName} SET updatedAt = strftime('%s', 'now') WHERE id = OLD.id;
    END;
    `,
  ];
};

export const TABLE_SCHEMAS = [
  ...generateTable(
    "subscription",
    `
    appName   TEXT,
    note      TEXT,
    `
  ),
  ...generateTable(
    "tag",
    `
  name      TEXT,
  color     TEXT,
  `
  ),
  ...generateTable(
    "orders",
    `
type INTEGER,
serviceId        INTEGER,
price              TEXT,
discount           TEXT,
note               TEXT,
orderDate          INTEGER,
activeDate         INTEGER,
timeExtension       TEXT,
autoProtocolPrice   TEXT,
autoPaymentCycle    INTEGER,
`
  ),
  ...generateTable(
    "service",
    `
  subscriptionId integer,
  name            text,
  note            text,
  `
  ),
];
