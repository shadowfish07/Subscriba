import { ScrollView, StyleSheet, View } from "react-native";
import { Card, TextInput, Text, Chip, IconButton } from "react-native-paper";
import { globalStyles } from "../../styles";
import { DraftSubscription } from "../../types";
import { useDraftSubscriptionStore } from "../../store/useDraftSubscriptionStore";
import { DraftServiceCard } from "./components/draftServiceCard";

type BasicInfoProps = {
  form: DraftSubscription;
  setBasicInfo: <T extends keyof DraftSubscription["basicInfo"]>(
    key: T,
    value: DraftSubscription["basicInfo"][T]
  ) => void;
};

const BasicInfo = ({
  form: {
    basicInfo: { appName, note },
  },
  setBasicInfo,
}: BasicInfoProps) => {
  return (
    <Card style={card}>
      <Card.Content>
        <TextInput
          label="应用名称"
          mode="outlined"
          value={appName}
          onChangeText={(text) => setBasicInfo("appName", text)}
          style={styles.input}
        />
        <TextInput
          label="备注"
          mode="outlined"
          value={note}
          onChangeText={(text) => setBasicInfo("note", text)}
          style={styles.input}
        />
        {/* <Text variant="labelMedium" style={{ marginTop: 15, marginBottom: 5 }}>
          标签
        </Text>
        <View
          style={{
            flexDirection: "row",
            alignItems: "center",
            flexWrap: "wrap",
          }}
        >
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>
          <Text style={{ marginRight: 5, marginBottom: 5 }}>
            <Chip selected>Example Chip</Chip>
          </Text>

          <IconButton icon="plus" size={20} style={{ height: 20 }} />
        </View> */}
      </Card.Content>
    </Card>
  );
};

export const Add = () => {
  const [draftSubscription, setBasicInfoKey, addService, deleteService] =
    useDraftSubscriptionStore((store) => [
      store.draftSubscription,
      store.setBasicInfoKey,
      store.setServiceKey,
      store.deleteService,
    ]);

  const renderServices = () => {
    function getSetFormKeyFn(index: number) {
      return (key: string, value: any) => addService(index, key, value);
    }

    return draftSubscription.services.map((service, index) => {
      return (
        <DraftServiceCard
          key={index}
          form={service}
          setFormKey={getSetFormKeyFn(index)}
          onCancel={() => deleteService(index)}
        />
      );
    });
  };

  return (
    <ScrollView>
      <BasicInfo form={draftSubscription} setBasicInfo={setBasicInfoKey} />
      {renderServices()}
      {/* <AddSubscriptionDialog
        onConfirm={function (selectedPlan: OrderTypeLabel): void {
          addSubscriptionPlan(subscriptionTypeLabel2Int(selectedPlan));
        }}
      /> */}
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {},
  input: {
    marginBottom: 10,
  },
  buttonInCard: {
    marginTop: 20,
  },
});

const card = StyleSheet.compose(globalStyles.card, styles.container);
