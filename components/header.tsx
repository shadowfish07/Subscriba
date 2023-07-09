import { Appbar } from "react-native-paper";
import { MoneyWithPerCost } from "./moneyWithPerCost";
import { NativeStackHeaderProps } from "@react-navigation/native-stack";
import { useDraftSubscriptionStore } from "../store/useDraftSubscriptionStore";
import { useDraftSubscription } from "../hooks/useDraftSubscription";

export const Header = (props: NativeStackHeaderProps) => {
  switch (props.route.name) {
    case "subscription-home":
      return <SubscriptionHomeHeader {...props} />;
    case "subscription-detail":
      return <SubscriptionDetailHeader {...props} />;
    case "subscription-add":
      return <SubscriptionAddHeader {...props} />;
    default:
      return null;
  }
};

const SubscriptionHomeHeader = ({
  navigation,
  back,
  options,
  route,
}: NativeStackHeaderProps) => {
  return (
    <Appbar.Header>
      {back && (
        <Appbar.BackAction
          onPress={() => {
            navigation.goBack();
          }}
        />
      )}
      <Appbar.Content title="订阅" />
      <MoneyWithPerCost />
    </Appbar.Header>
  );
};

const SubscriptionDetailHeader = ({
  navigation,
  back,
  options,
  route,
}: NativeStackHeaderProps) => {
  return (
    <Appbar.Header>
      {back && (
        <Appbar.BackAction
          onPress={() => {
            navigation.goBack();
          }}
        />
      )}
      <Appbar.Content title={(route.params as any).appName} />
    </Appbar.Header>
  );
};

const SubscriptionAddHeader = ({
  navigation,
  back,
  options,
  route,
}: NativeStackHeaderProps) => {
  const { saveSubscription } = useDraftSubscription();

  return (
    <Appbar.Header>
      {back && (
        <Appbar.BackAction
          onPress={() => {
            navigation.goBack();
          }}
        />
      )}
      <Appbar.Content title="添加应用" />
      <Appbar.Action
        icon="content-save"
        onPress={() => {
          // TODO 校验
          saveSubscription().then(() => {
            navigation.goBack();
          });
        }}
      />
    </Appbar.Header>
  );
};
