import {
  SQLResultSetRowList,
  SQLTransaction,
  WebSQLDatabase,
} from "expo-sqlite";
import {
  DraftOrder,
  DraftSubscription,
  PriceInfoOfSubscriptionPlan,
  Subscription,
  SubscriptionDetail,
  SubscriptionPlanType,
  SupportedDraftSubscriptionPlans,
} from "../types";
import {
  AutoSubscriptionPlanModal,
  BuyoutSubscriptionPlanModal,
  ManualSubscriptionPlanModal,
  OrdersModal,
  SubscriptionModal,
} from "../modals";
import dayjs from "dayjs";
import { Money } from "./money";
import { merge } from "lodash";

export class DatabaseService {
  constructor(private db: WebSQLDatabase) {}

  private executeSql = async <T = unknown>(
    sql: string,
    args: any[] = [],
    tx?: SQLTransaction
  ): Promise<T[]> => {
    console.info("exec sql", sql, args);
    return new Promise((resolve, reject) => {
      if (!tx) {
        this.db.transaction(
          (tx) => {
            tx.executeSql(sql, args, (_, { rows }) => {
              console.info(
                "exec sql(mode 1)",
                sql,
                JSON.stringify(args),
                rows._array
              );
              resolve(rows._array);
            });
          },
          (error) => {
            console.error(
              "🚀 ~ file: databaseService.ts:55 ~ DatabaseService ~ returnnewPromise ~ error:",
              error
            );
            reject(error);
            return true;
          }
        );
      } else {
        tx.executeSql(
          sql,
          args,
          (_, { rows }) => {
            console.info(
              "exec sql(mode 2)",
              sql,
              JSON.stringify(args),
              rows._array
            );

            resolve(rows._array);
          },
          (_, err) => {
            console.error(
              "🚀 ~ file: databaseService.ts:59 ~ DatabaseService ~ returnnewPromise ~ err:",
              err
            );
            reject(err);
            return true;
          }
        );
      }
    });
  };

  insertOrder = async (
    subscriptionPlanId: number,
    subscriptionPlanType: number,
    order: DraftOrder
  ): Promise<unknown[]> => {
    function transformTimeExtensionToDayUnit(value: string) {
      if (value[value.length - 1] === "d") {
        return value;
      } else if (value[value.length - 1] === "m") {
        return Number(value.slice(0, value.length - 1)) * 31 + "d";
      } else {
        return Number(value.slice(0, value.length - 1)) * 365 + "d";
      }
    }

    return this.executeSql(
      "INSERT INTO orders (subscriptionPlanId,subscriptionPlanType,price,discount,note,orderDate,timeExtension) VALUES (?,?,?,?,?,?,?)",
      [
        subscriptionPlanId,
        subscriptionPlanType,
        order.price,
        null,
        order.note,
        order.orderDate,
        transformTimeExtensionToDayUnit(order.timeExtension),
      ]
    );
  };

  getLastInsertRowId = async (): Promise<number> => {
    return (
      await this.executeSql<{
        id: number;
      }>("SELECT LAST_INSERT_ROWID() AS id")
    )[0].id;
  };

  createSubscription = async (
    draftSubscription: DraftSubscription
  ): Promise<void> => {
    return new Promise((resolve, reject) => {
      // FIXME 后面this.executeSql加了,tx就会导致sql不执行
      // https://github.com/expo/expo/issues/1889
      // 似乎transaction的第一个参数并不支持async
      this.db.transaction(
        async (tx) => {
          await this.executeSql(
            "INSERT INTO subscription (appName, note) VALUES (?, ?)",
            [
              draftSubscription.basicInfo.appName,
              draftSubscription.basicInfo.note,
            ],
            tx
          );

          const subscriptionId = await this.getLastInsertRowId();

          for (const plan of draftSubscription.subscriptionPlans) {
            let subscriptionPlanId: number;
            switch (plan.type) {
              case SubscriptionPlanType.Manual:
                await this.executeSql(
                  "INSERT INTO manual_subscription_plan (subscriptionId,serviceName) VALUES (?,?)",
                  [subscriptionId, plan.serviceName]
                );
                subscriptionPlanId = await this.getLastInsertRowId();
                for (const order of plan.orders) {
                  await this.insertOrder(
                    subscriptionPlanId,
                    SubscriptionPlanType.Manual,
                    order
                  );
                }
                break;
              case SubscriptionPlanType.Buyout:
                await this.executeSql(
                  "INSERT INTO buyout_subscription_plan (subscriptionId,serviceName) VALUES (?,?)",
                  [subscriptionId, plan.serviceName]
                );
                subscriptionPlanId = await this.getLastInsertRowId();
                for (const order of plan.orders) {
                  await this.insertOrder(
                    subscriptionPlanId,
                    SubscriptionPlanType.Buyout,
                    order
                  );
                }
                break;
              case SubscriptionPlanType.Auto:
                await this.executeSql(
                  "INSERT INTO auto_subscription_plan (subscriptionId,serviceName,startAt,protocolPrice,paymentCycle) VALUES (LAST_INSERT_ROWID(),?,?,?,?)",
                  [
                    plan.serviceName,
                    plan.startAt,
                    plan.protocolPrice,
                    plan.paymentCycle,
                  ]
                );
            }
          }

          resolve();
        },
        (error) => {
          reject(error);
        }
      );
    });
  };

  selectSubscriptions = async (): Promise<SubscriptionModal[]> => {
    return this.executeSql("SELECT * FROM subscription");
  };

  selectSubscription = async (
    subscriptionId: number
  ): Promise<SubscriptionModal> => {
    return (
      await this.executeSql<SubscriptionModal>(
        "SELECT * FROM subscription WHERE id = ?",
        [subscriptionId]
      )
    )[0];
  };

  selectOrders = async (): Promise<OrdersModal[]> => {
    return this.executeSql("SELECT * FROM orders");
  };

  selectManualSubscriptionPlans = async (
    subscriptionId: number
  ): Promise<ManualSubscriptionPlanModal[]> => {
    return this.executeSql(
      "SELECT *, 0 AS type FROM manual_subscription_plan WHERE subscriptionId = ?",
      [subscriptionId]
    );
  };

  selectAutoSubscriptionPlans = async (
    subscriptionId: number
  ): Promise<AutoSubscriptionPlanModal[]> => {
    return this.executeSql(
      "SELECT *, 1 AS type FROM auto_subscription_plan WHERE subscriptionId = ?",
      [subscriptionId]
    );
  };

  selectBuyoutSubscriptionPlans = async (
    subscriptionId: number
  ): Promise<BuyoutSubscriptionPlanModal[]> => {
    return this.executeSql(
      "SELECT *, 2 AS type FROM buyout_subscription_plan WHERE subscriptionId = ?",
      [subscriptionId]
    );
  };

  getPriceInfoOfSubscriptionPlan = async (
    subscriptionPlanId: number,
    subscriptionPlanType: SubscriptionPlanType
  ): Promise<PriceInfoOfSubscriptionPlan> => {
    const orders = await this.executeSql<OrdersModal>(
      "SELECT * FROM orders WHERE subscriptionPlanId = ? AND subscriptionPlanType = ?",
      [subscriptionPlanId, subscriptionPlanType]
    );
    const totalPrice = Money.sum(
      ...orders.map((order) => order.price)
    ).toString();
    return {
      totalPrice,
      orders,
    };
  };

  getSubscriptionList = async (): Promise<Subscription[]> => {
    const getOrdersOfPlans = async (
      plans: (
        | ManualSubscriptionPlanModal
        | BuyoutSubscriptionPlanModal
        | AutoSubscriptionPlanModal
      )[]
    ) => {
      let result = [];
      for (const plan of plans) {
        const orders = await this.executeSql<OrdersModal>(
          "SELECT * FROM orders WHERE subscriptionPlanId = ? AND subscriptionPlanType = ? ORDER BY orderDate ASC",
          [plan.id, plan.type]
        );
        result = result.concat(orders);
      }

      return result;
    };

    const result = [];
    const subscriptions = await this.selectSubscriptions();

    for (const subscription of subscriptions) {
      const manualSubscriptionPlans = await this.selectManualSubscriptionPlans(
        subscription.id
      );
      const autoSubscriptionPlans = await this.selectAutoSubscriptionPlans(
        subscription.id
      );
      const buyoutSubscriptionPlans = await this.selectBuyoutSubscriptionPlans(
        subscription.id
      );

      const orders = [
        ...(await getOrdersOfPlans(manualSubscriptionPlans)),
        ...(await getOrdersOfPlans(autoSubscriptionPlans)),
        ...(await getOrdersOfPlans(buyoutSubscriptionPlans)),
      ];

      result.push({
        ...subscription,
        orders,
      });
    }

    return result;
  };

  getSubscriptionDetail = async (
    subscriptionId: number
  ): Promise<SubscriptionDetail> => {
    const mergePriceInfo = async (
      plans: (
        | ManualSubscriptionPlanModal
        | BuyoutSubscriptionPlanModal
        | AutoSubscriptionPlanModal
      )[]
    ) => {
      for (const plan of plans) {
        merge(
          plan,
          await this.getPriceInfoOfSubscriptionPlan(plan.id, plan.type)
        );
      }
    };

    const basicInfo = await this.selectSubscription(subscriptionId);

    const manualSubscriptionPlans = await this.selectManualSubscriptionPlans(
      subscriptionId
    );

    const autoSubscriptionPlans = await this.selectAutoSubscriptionPlans(
      subscriptionId
    );
    const buyoutSubscriptionPlans = await this.selectBuyoutSubscriptionPlans(
      subscriptionId
    );

    await mergePriceInfo(manualSubscriptionPlans);
    await mergePriceInfo(autoSubscriptionPlans);
    await mergePriceInfo(buyoutSubscriptionPlans);

    return {
      basicInfo,
      subscriptionPlans: []
        .concat(manualSubscriptionPlans)
        .concat(autoSubscriptionPlans)
        .concat(buyoutSubscriptionPlans)
        .sort(
          (a, b) => dayjs(b.createdAt).valueOf() - dayjs(a.createdAt).valueOf()
        ),
    };
  };

  insertSubscriptionPlan = async (
    subscriptionId: number,
    plan: SupportedDraftSubscriptionPlans
  ): Promise<void> => {
    switch (plan.type) {
      case SubscriptionPlanType.Manual:
        await this.executeSql(
          "INSERT INTO manual_subscription_plan (subscriptionId,serviceName) VALUES (?,?)",
          [subscriptionId, plan.serviceName]
        );
        break;
      case SubscriptionPlanType.Auto:
        await this.executeSql(
          "INSERT INTO auto_subscription_plan (subscriptionId,serviceName,startAt,protocolPrice,paymentCycle) VALUES (?,?,?,?,?)",
          [
            subscriptionId,
            plan.serviceName,
            plan.startAt,
            plan.protocolPrice,
            plan.paymentCycle,
          ]
        );
        break;
      case SubscriptionPlanType.Buyout:
        await this.executeSql(
          "INSERT INTO buyout_subscription_plan (subscriptionId,serviceName) VALUES (?,?)",
          [subscriptionId, plan.serviceName]
        );
        break;
    }
  };
}
