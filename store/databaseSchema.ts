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
];

export const TABLE_SCHEMAS = [
  `
    create table auto_subscription_plan
(
    id                 INTEGER
        constraint subscription_pk
            primary key autoincrement,
    subscriptionId INTEGER,
    serviceName    TEXT,
    startAt            INTEGER,
    protocolPrice      INTEGER,
    paymentCycle       INTEGER,
    createdAt          TEXT default CURRENT_TIMESTAMP,
    updatedAt          TEXT default CURRENT_TIMESTAMP
);
    `,
  `
    CREATE TRIGGER update_auto_subscription_plan_updatedAt
AFTER UPDATE ON auto_subscription_plan
FOR EACH ROW
BEGIN
    UPDATE auto_subscription_plan SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;`,
  `create table buyout_subscription_plan
(
    id                 INTEGER
        constraint subscription_pk
            primary key autoincrement,
    subscriptionId INTEGER,
    serviceName        TEXT,
    createdAt          TEXT default CURRENT_TIMESTAMP,
    updatedAt          TEXT default CURRENT_TIMESTAMP
);
`,
  `
CREATE TRIGGER update_buyout_subscription_plan_updatedAt
AFTER UPDATE ON buyout_subscription_plan
FOR EACH ROW
BEGIN
    UPDATE buyout_subscription_plan SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;
`,
  `
create table manual_subscription_plan
(
    id                 INTEGER
        constraint subscription_pk
            primary key autoincrement,
    subscriptionId INTEGER,
    serviceName        TEXT,
    createdAt          TEXT default CURRENT_TIMESTAMP,
    updatedAt          TEXT default CURRENT_TIMESTAMP
);

CREATE TRIGGER update_manual_subscription_plan_updatedAt
AFTER UPDATE ON manual_subscription_plan
FOR EACH ROW
BEGIN
    UPDATE manual_subscription_plan SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;
`,
  `
create table subscription
(
    id        INTEGER
        constraint subscription_pk
            primary key autoincrement,
    appName   TEXT,
    note      TEXT,
    createdAt TEXT default CURRENT_TIMESTAMP,
    updatedAt TEXT default CURRENT_TIMESTAMP
);`,
  `CREATE TRIGGER update_subscription_updatedAt
AFTER UPDATE ON subscription
FOR EACH ROW
BEGIN
    UPDATE subscription SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;
`,
  `
create table tag
(
    id        INTEGER
        constraint subscription_pk
            primary key autoincrement,
    name      TEXT,
    color     TEXT,
    createdAt TEXT default CURRENT_TIMESTAMP,
    updatedAt TEXT default CURRENT_TIMESTAMP
);`,
  `
CREATE TRIGGER update_tag_updatedAt
AFTER UPDATE ON tag
FOR EACH ROW
BEGIN
    UPDATE tag SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;`,
  `create table orders
  (
      id                 INTEGER
          constraint orders_pk
              primary key autoincrement,
      subscriptionPlanId INTEGER,
      subscriptionPlanType INTEGER,
      price              TEXT,
      discount           TEXT,
      note               TEXT,
      createdAt          TEXT default CURRENT_TIMESTAMP,
      updatedAt          TEXT default CURRENT_TIMESTAMP,
      orderDate          INTEGER,
      timeExtension       TEXT
);
`,
  `CREATE TRIGGER update_orders_updatedAt
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    UPDATE orders SET updatedAt = CURRENT_TIMESTAMP WHERE id = OLD.id;
END;
`,
];
