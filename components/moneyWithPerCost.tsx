import { StyleSheet, View } from "react-native";
import { Text, TouchableRipple, useTheme } from "react-native-paper";
import Icon from "react-native-vector-icons/MaterialCommunityIcons";
import { usePerUnitStore } from "../store/usePerUnitStore";
import { usePerUnit } from "../hooks/usePerUnit";
import { useData } from "../hooks/useData";
import { Money } from "../util/money";

export const MoneyWithPerCost = () => {
  const theme = useTheme();
  const { unit, setNextUnit, calculateServicesPerCost } = usePerUnit(true);
  const { data: services } = useData("getAllServices", []);

  if (!services) return null;

  return (
    <TouchableRipple style={styles.container} onPress={setNextUnit}>
      <View style={{ flexDirection: "row", alignItems: "center" }}>
        <View style={{ alignItems: "flex-end" }}>
          <Text
            theme={{ colors: { onSurface: theme.colors.primary } }}
            variant="labelSmall"
            style={styles.money}
          >
            {unit}
          </Text>
          <Text variant="titleLarge" style={styles.per}>
            {new Money(calculateServicesPerCost(services)).toString(2)}
          </Text>
        </View>
        <Icon name="menu-swap" size={16} color={theme.colors.onSurface} />
      </View>
    </TouchableRipple>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: "flex-end",
    paddingRight: 15,
  },
  money: {
    marginBottom: -2,
  },
  per: {},
});
