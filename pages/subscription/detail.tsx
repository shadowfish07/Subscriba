import { View, StyleSheet, ScrollView, Dimensions } from "react-native";
import {
  Button,
  Card,
  List,
  Text,
  TouchableRipple,
  useTheme,
} from "react-native-paper";
import { globalStyles } from "../../styles";
import Icon from "react-native-vector-icons/MaterialCommunityIcons";
import { LineChart } from "react-native-chart-kit";
import { RouteProp, useRoute } from "@react-navigation/native";
import {
  DraftOrder,
  RouteParams,
  SubscriptionDetail,
  Service,
  DraftService,
} from "../../types";
import { useDatabase } from "../../hooks/useDatabase";
import { useState } from "react";
import { useData } from "../../hooks/useData";
import { Orders } from "./components/orders";
import { OrderCalculator } from "../../util/orderCalculator";
import { DraftServiceCard } from "./components/draftServiceCard";
import { OrdersModal } from "../../modals";
import { usePerUnit } from "../../hooks/usePerUnit";
import { PerUnit } from "../../store/usePerUnitStore";

type BasicInfoProps = {
  basicInfo: SubscriptionDetail["basicInfo"];
  orders: OrdersModal[];
};
const BasicInfo = ({ basicInfo, orders }: BasicInfoProps) => {
  const theme = useTheme();
  const calculator = new OrderCalculator(orders);
  const { unit, setNextUnit } = usePerUnit();

  const ordersPerCost = calculator.getPerCost(unit);

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">首次订阅</Text>}
            description={
              <Text variant="bodyLarge">{calculator.startTime || "-"}</Text>
            }
          />
          <List.Item
            title={<Text variant="labelMedium">{unit}</Text>}
            description={() => (
              <TouchableRipple
                onPress={() => {
                  setNextUnit();
                }}
              >
                <View style={{ flexDirection: "row", alignItems: "center" }}>
                  <Text variant="bodyLarge">{ordersPerCost || "-"}</Text>
                  <Icon
                    name="menu-swap"
                    size={16}
                    color={theme.colors.onSurface}
                  />
                </View>
              </TouchableRipple>
            )}
          />
          {/* <List.Item
            title={<Text variant="labelMedium">标签</Text>}
            description={<Chip compact>Example Chip</Chip>}
            descriptionStyle={{ paddingTop: 5 }}
          /> */}
        </View>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">总计花费</Text>}
            description={
              <Text variant="bodyLarge">{calculator.totalCost || "-"}</Text>
            }
          />
        </View>
      </View>
      <List.Item
        title={<Text variant="labelMedium">备注</Text>}
        description={<Text variant="bodyLarge">{basicInfo.note}</Text>}
      />
    </Card>
  );
};

type ServiceCardProps = {
  service: Service;
  onAddOrder: (order: DraftOrder) => void;
};
// 订阅不设置协议价格，买断
const ServiceCard = ({ service, onAddOrder }: ServiceCardProps) => {
  const calculator = new OrderCalculator(service.orders);

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">订阅服务名称</Text>}
            description={<Text variant="bodyLarge">{service.name}</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">开始时间</Text>}
            description={
              <Text variant="bodyLarge">{calculator.startTime}</Text>
            }
          />
        </View>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">备注</Text>}
            description={<Text variant="bodyLarge">{service.note || "-"}</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">到期时间</Text>}
            description={<Text variant="bodyLarge">{calculator.endTime}</Text>}
          />
        </View>
      </View>
      <Orders
        containerStyle={{ marginHorizontal: 16 }}
        orders={service.orders}
        onAdd={onAddOrder}
      />
    </Card>
  );
};

const HistoryPrice = () => {
  return (
    <Card style={mergedStyles.card}>
      <Card.Title
        titleVariant="titleLarge"
        title="历史价格"
        style={{ marginBottom: -10 }}
      />
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">历史低价</Text>}
            description={<Text variant="bodyLarge">$10/月</Text>}
          />
        </View>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">历史高价</Text>}
            description={<Text variant="bodyLarge">$20/月</Text>}
          />
        </View>
      </View>
      <View style={{ alignItems: "center" }}>
        <HistoryPriceChart />
      </View>
      <Card.Actions>
        <Button mode="contained">记录当前价格</Button>
      </Card.Actions>
    </Card>
  );
};

const HistoryPriceChart = () => {
  return (
    <View>
      <LineChart
        data={{
          labels: [
            "2011",
            "2011",
            "2011",
            "2011",
            "2011",
            "2011",
            "2011",
            "2011",
          ],
          datasets: [
            {
              data: [
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
                Math.random() * 100,
              ],
            },
          ],
        }}
        width={Dimensions.get("window").width - 60}
        height={170}
        yAxisLabel="$"
        withInnerLines={false}
        withOuterLines={false}
        hidePointsAtIndex={[1, 3, 4, 5, 6, 7]}
        yAxisInterval={1} // optional, defaults to 1
        chartConfig={{
          backgroundColor: "#121212 ",
          backgroundGradientFrom: "#1E1E1E",
          backgroundGradientTo: "#121212",
          decimalPlaces: 2, // optional, defaults to 2dp
          color: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
          labelColor: (opacity = 1) => `rgba(255, 255, 255, ${opacity})`,
          style: {
            borderRadius: 16,
          },
          propsForDots: {
            r: "3",
            strokeWidth: "2",
            stroke: "#1E1E1E",
          },
        }}
        bezier
        style={{
          marginVertical: 8,
          borderRadius: 16,
        }}
      />
    </View>
  );
};

export const Detail = () => {
  const route = useRoute<RouteProp<RouteParams, "SubscriptionDetail">>();
  const [draftServices, setDraftServices] = useState<number[]>([]);
  const id = route.params.id;
  const { databaseService } = useDatabase();
  const { data, load } = useData("getSubscriptionDetail", [id]);

  if (!data) return null;

  const renderServices = () => {
    return data.services.map((service) => {
      const handleAddOrder = async (order: DraftOrder) => {
        await databaseService.insertOrder({ ...order, serviceId: service.id });
        load();
      };
      return (
        <ServiceCard
          key={service.id}
          service={service}
          onAddOrder={handleAddOrder}
        />
      );
    });
  };

  const renderDraftService = () => {
    const getHandleSave = (index: number) => (form: DraftService) => {
      databaseService.insertService({ ...form, subscriptionId: id });
      load().then(() => {
        getHandleClose(index)();
      });
    };

    const getHandleClose = (index: number) => {
      return () => {
        setDraftServices(draftServices.filter((_, i) => i !== index));
      };
    };

    return draftServices.map((_, index) => {
      return (
        <DraftServiceCard
          key={index}
          showSaveButton
          onSave={getHandleSave(index)}
          onCancel={getHandleClose(index)}
        />
      );
    });
  };

  return (
    <ScrollView style={styles.container}>
      <BasicInfo
        basicInfo={data.basicInfo}
        orders={data.services.reduce((prev, curr) => {
          return prev.concat(curr.orders);
        }, [])}
      />
      {/* <HistoryPrice /> */}
      {renderServices()}
      {renderDraftService()}
      <Button
        style={mergedStyles.card}
        mode="text"
        onPress={() => {
          setDraftServices([...draftServices, 0]);
        }}
      >
        新增订阅服务
      </Button>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {},
  cardTitle: {
    marginBottom: -10,
  },
});

const mergedStyles = {
  ...globalStyles,
  ...styles,
};
