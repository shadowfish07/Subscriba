import {
  Appbar,
  Button,
  Dialog,
  Portal,
  Text,
  useTheme,
} from "react-native-paper";
import { MoneyWithPerCost } from "./moneyWithPerCost";
import { NativeStackHeaderProps } from "@react-navigation/native-stack";
import { useDraftSubscriptionStore } from "../store/useDraftSubscriptionStore";
import { useDraftSubscription } from "../hooks/useDraftSubscription";
import { useDatabase } from "../hooks/useDatabase";
import { useState } from "react";

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
  const theme = useTheme();
  const { databaseService } = useDatabase();
  const [visible, setVisible] = useState(false);

  const showDialog = () => setVisible(true);
  const hideDialog = () => setVisible(false);

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
      <Appbar.Action
        icon="trash-can-outline"
        onPress={() => {
          showDialog();
        }}
      />
      <Portal>
        <Dialog visible={visible} onDismiss={hideDialog}>
          <Dialog.Title>确认删除</Dialog.Title>
          <Dialog.Content>
            <Text>确定删除整个订阅吗？该操作不可撤销！</Text>
          </Dialog.Content>
          <Dialog.Actions>
            <Button
              onPress={() => {
                databaseService
                  .deleteSubscription((route.params as any).id)
                  .then(() => {
                    navigation.goBack();
                  });
              }}
            >
              <Text style={{ color: theme.colors.error }}>删除</Text>
            </Button>
            <Button onPress={hideDialog}>取消</Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
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
