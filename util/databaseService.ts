import { SQLTransaction, WebSQLDatabase } from "expo-sqlite";
import {
  DraftSubscription,
  Subscription,
  SubscriptionDetail,
  Draft,
  Service,
} from "../types";
import { OrdersModal, ServiceModal, SubscriptionModal } from "../modals";

export class DatabaseService {
  constructor(private db: WebSQLDatabase) {}

  private executeSql = async <T = unknown>(
    sql: string,
    args: any[] = [],
    tx?: SQLTransaction
  ): Promise<T[]> => {
    console.info(Date.now(), "exec sql", sql, args);
    return new Promise((resolve, reject) => {
      if (!tx) {
        this.db.transaction(
          (tx) => {
            tx.executeSql(sql, args, (_, { rows }) => {
              console.info(
                Date.now(),
                "exec sql(mode 1) success",
                sql,
                JSON.stringify(args),
                rows._array
              );
              resolve(rows._array);
            });
          },
          (error) => {
            console.error(
              Date.now(),
              "SQL error:",
              sql,
              JSON.stringify(args),
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
              "exec sql(mode 2) success",
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

  insertOrder = async (order: Draft<OrdersModal>): Promise<unknown[]> => {
    return this.executeSql(
      "INSERT INTO orders (serviceId,type,price,discount,note,orderDate,activeDate,timeExtension,includeInTheAverage) VALUES (?,?,?,?,?,?,?,?,?)",
      [
        order.serviceId,
        order.type,
        order.price,
        null,
        order.note,
        order.orderDate,
        order.activeDate,
        order.timeExtension,
        order.includeInTheAverage,
      ]
    );
  };

  insertService = async (service: Draft<ServiceModal>): Promise<unknown[]> => {
    return this.executeSql(
      "INSERT INTO service (subscriptionId,name,note) VALUES (?,?,?)",
      [service.subscriptionId, service.name, service.note]
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

          for (const service of draftSubscription.services) {
            await this.insertService({
              ...service,
              subscriptionId: subscriptionId,
            });

            const serviceId = await this.getLastInsertRowId();

            for (const order of service.orders) {
              await this.insertOrder({ ...order, serviceId: serviceId });
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

  selectOrders = async (serviceId: number): Promise<OrdersModal[]> => {
    return this.executeSql("SELECT * FROM orders WHERE serviceId = ?", [
      serviceId,
    ]);
  };

  selectServices = async (subscriptionId: number): Promise<ServiceModal[]> => {
    return this.executeSql<ServiceModal>(
      "SELECT * FROM service WHERE subscriptionId = ?",
      [subscriptionId]
    );
  };

  deleteSubscription = async (subscriptionId: number): Promise<void> => {
    await this.executeSql("DELETE FROM subscription WHERE id = ?", [
      subscriptionId,
    ]);
  };

  deleteService = async (serviceId: number): Promise<void> => {
    await this.executeSql("DELETE FROM service WHERE id = ?", [serviceId]);
  };

  selectOrdersOfSubscription = async (
    subscriptionId: number
  ): Promise<OrdersModal[]> => {
    return this.executeSql<OrdersModal>(
      `SELECT * FROM orders WHERE serviceId IN (
        SELECT id FROM service WHERE subscriptionId = ?
      )`,
      [subscriptionId]
    );
  };

  getAllServices = async (): Promise<Service[]> => {
    const subscriptions = await this.selectSubscriptions();

    const services = (
      await Promise.all(subscriptions.map(({ id }) => this.selectServices(id)))
    ).flat();

    return Promise.all(
      services.map(async (service) => {
        return {
          ...service,
          orders: await this.selectOrders(service.id),
        };
      })
    );
  };

  getServicesOfSubscription = async (
    subscriptionId: number
  ): Promise<Service[]> => {
    const services = await this.selectServices(subscriptionId);

    return Promise.all(
      services.map(async (service) => {
        return {
          ...service,
          orders: await this.selectOrders(service.id),
        };
      })
    );
  };

  getSubscriptionList = async (): Promise<Subscription[]> => {
    const result = [];
    const subscriptions = await this.selectSubscriptions();

    for (const subscription of subscriptions) {
      result.push({
        ...subscription,
        orders: await this.selectOrdersOfSubscription(subscription.id),
        services: await this.getServicesOfSubscription(subscription.id),
      });
    }

    return result;
  };

  getSubscriptionDetail = async (
    subscriptionId: number
  ): Promise<SubscriptionDetail> => {
    const basicInfo = await this.selectSubscription(subscriptionId);
    const services = (await this.selectServices(subscriptionId)) as Service[];

    for (const service of services) {
      service.orders = await this.selectOrders(service.id);
    }

    return {
      basicInfo,
      services,
    };
  };
}
