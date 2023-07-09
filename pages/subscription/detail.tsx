import { View, StyleSheet, ScrollView, Dimensions } from "react-native";
import {
  Button,
  Card,
  Chip,
  List,
  Surface,
  Text,
  TouchableRipple,
  useTheme,
} from "react-native-paper";
import { globalStyles } from "../../styles";
import Icon from "react-native-vector-icons/MaterialCommunityIcons";
import { LineChart } from "react-native-chart-kit";
import { RouteProp, useRoute } from "@react-navigation/native";
import {
  BuyoutSubscriptionPlan,
  DraftOrder,
  ManualSubscriptionPlan,
  PaymentCycle,
  RouteParams,
  SubscriptionDetail,
  SubscriptionPlanType,
  SupportedDraftSubscriptionPlans,
} from "../../types";
import { useDatabase } from "../../hooks/useDatabase";
import { useEffect, useState } from "react";
import {
  AutoSubscriptionPlanModal,
  BuyoutSubscriptionPlanModal,
  ManualSubscriptionPlanModal,
} from "../../modals";
import { formatDate } from "../../util/formatDate";
import { paymentCycle2String } from "../../util/paymentCycle2String";
import { useData } from "../../hooks/useData";
import { AddSubscriptionDialog } from "./components/addSubsriptionDialog";
import { DraftManualSubscriptionPlanCard } from "./components/draftManualSubsciptionPlanCard";
import { DraftAutoSubscriptionPlanCard } from "./components/draftAutoSubsciptionPlanCard";
import { DraftBuyoutSubscriptionPlanCard } from "./components/draftBuyoutSubsciptionPlanCard";
import { subscriptionTypeLabel2Int } from "../../util/subscriptionTypeLabel2Int";
import { Orders } from "./components/orders";
import { PlanDetailCalculator } from "../../util/planDetailCalculator";

type BasicInfoProps = {
  basicInfo: SubscriptionDetail["basicInfo"];
};
const BasicInfo = ({ basicInfo }: BasicInfoProps) => {
  const theme = useTheme();

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">首次订阅</Text>}
            description={<Text variant="bodyLarge">-</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">每月花费</Text>}
            description={() => (
              <TouchableRipple onPress={() => {}}>
                <View style={{ flexDirection: "row", alignItems: "center" }}>
                  <Text variant="bodyLarge">-</Text>
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
            description={<Text variant="bodyLarge">-</Text>}
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

type ManualSubscriptionPlanProps = {
  plan: ManualSubscriptionPlan;
  onAddOrder: (order: DraftOrder) => void;
};
// 订阅不设置协议价格，买断
const ManualSubscriptionPlanComp = ({
  plan,
  onAddOrder,
}: ManualSubscriptionPlanProps) => {
  const calculator = new PlanDetailCalculator(plan);

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">订阅类型</Text>}
            description={<Text variant="bodyLarge">手动订阅</Text>}
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
            title={<Text variant="labelMedium">订阅服务名称</Text>}
            description={<Text variant="bodyLarge">{plan.serviceName}</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">到期时间</Text>}
            description={<Text variant="bodyLarge">{calculator.endTime}</Text>}
          />
        </View>
      </View>
      <Orders
        containerStyle={{ marginHorizontal: 16 }}
        orders={plan.orders}
        onAdd={onAddOrder}
        subscriptionPlanType={SubscriptionPlanType.Manual}
      />
    </Card>
  );
};

type BuyoutSubscriptionPlanProps = {
  plan: BuyoutSubscriptionPlan;
  onAddOrder: (order: DraftOrder) => void;
};
const BuyoutSubscriptionPlanComp = ({
  plan,
  onAddOrder,
}: BuyoutSubscriptionPlanProps) => {
  const calculator = new PlanDetailCalculator(plan);

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">订阅类型</Text>}
            description={<Text variant="bodyLarge">买断</Text>}
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
            title={<Text variant="labelMedium">订阅服务名称</Text>}
            description={<Text variant="bodyLarge">{plan.serviceName}</Text>}
          />
        </View>
      </View>
      <Orders
        containerStyle={{ marginHorizontal: 16 }}
        orders={plan.orders}
        onAdd={onAddOrder}
        subscriptionPlanType={SubscriptionPlanType.Buyout}
      />
    </Card>
  );
};

type AutoSubscriptionPlanProps = {
  plan: AutoSubscriptionPlanModal;
};
const AutoSubscriptionPlanComp = ({ plan }: AutoSubscriptionPlanProps) => {
  const title =
    plan.paymentCycle === PaymentCycle.Monthly ? "连续包月" : "连续包年";

  return (
    <Card style={mergedStyles.card}>
      <View style={{ flexDirection: "row" }}>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">订阅类型</Text>}
            description={<Text variant="bodyLarge">{title}</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">开始时间</Text>}
            description={
              <Text variant="bodyLarge">{formatDate(plan.createdAt)}</Text>
            }
          />
          <List.Item
            title={<Text variant="labelMedium">协议价格</Text>}
            description={
              <Text variant="bodyLarge">{`${
                plan.protocolPrice
              }/${paymentCycle2String(plan.paymentCycle)}`}</Text>
            }
          />
        </View>
        <View style={{ flex: 1 }}>
          <List.Item
            title={<Text variant="labelMedium">订阅服务名称</Text>}
            description={<Text variant="bodyLarge">{plan.serviceName}</Text>}
          />
          <List.Item
            title={<Text variant="labelMedium">到期时间</Text>}
            description={<Text variant="bodyLarge">0</Text>}
          />
        </View>
      </View>
      {/* <List.Item
        title={<Text>账单</Text>}
        right={() => {
          return (
            <View style={{ flexDirection: "row", alignItems: "center" }}>
              <Text style={{ lineHeight: 16, color: theme.colors.primary }}>
                $158
              </Text>
              <Icon
                name="chevron-right"
                size={16}
                color={theme.colors.primary}
              />
            </View>
          );
        }}
      /> */}
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
  const [draftPlans, setDraftPlans] = useState<SubscriptionPlanType[]>([]);
  const id = route.params.id;
  const { databaseService } = useDatabase();
  const { data, load } = useData("getSubscriptionDetail", [id]);

  if (!data) return null;

  const renderPlans = () => {
    return data.subscriptionPlans.map((plan) => {
      const handleAddOrder = async (order: DraftOrder) => {
        await databaseService.insertOrder(plan.id, plan.type, order);
        load();
      };
      switch (plan.type) {
        case SubscriptionPlanType.Manual:
          return (
            <ManualSubscriptionPlanComp
              key={plan.type.toString() + plan.id}
              plan={plan}
              onAddOrder={handleAddOrder}
            />
          );
        case SubscriptionPlanType.Auto:
          return (
            <AutoSubscriptionPlanComp
              key={plan.type.toString() + plan.id}
              plan={plan}
            />
          );
        case SubscriptionPlanType.Buyout:
          return (
            <BuyoutSubscriptionPlanComp
              key={plan.type.toString() + plan.id}
              plan={plan}
              onAddOrder={handleAddOrder}
            />
          );
      }
    });
  };

  const renderDraftPlans = () => {
    const getHandleSave =
      (index: number) => (form: SupportedDraftSubscriptionPlans) => {
        databaseService.insertSubscriptionPlan(id, form);
        load().then(() => {
          getHandleClose(index)();
        });
      };

    const getHandleClose = (index: number) => {
      return () => {
        setDraftPlans(draftPlans.filter((_, i) => i !== index));
      };
    };

    return draftPlans.map((type, index) => {
      switch (type) {
        case SubscriptionPlanType.Manual:
          return (
            <DraftManualSubscriptionPlanCard
              key={index}
              showSaveButton
              onSave={getHandleSave(index)}
              onCancel={getHandleClose(index)}
            />
          );
        case SubscriptionPlanType.Auto:
          return (
            <DraftAutoSubscriptionPlanCard
              key={index}
              showSaveButton
              onSave={getHandleSave(index)}
              onCancel={getHandleClose(index)}
            />
          );
        case SubscriptionPlanType.Buyout:
          return (
            <DraftBuyoutSubscriptionPlanCard
              key={index}
              showSaveButton
              onSave={getHandleSave(index)}
              onCancel={getHandleClose(index)}
            />
          );
      }
    });
  };

  return (
    <ScrollView style={styles.container}>
      <BasicInfo basicInfo={data.basicInfo} />
      {/* <HistoryPrice /> */}
      {renderDraftPlans()}
      {renderPlans()}
      <AddSubscriptionDialog
        onConfirm={(type) => {
          setDraftPlans([subscriptionTypeLabel2Int(type), ...draftPlans]);
        }}
      />
      <Button style={mergedStyles.card} mode="text">
        修改/删除
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
