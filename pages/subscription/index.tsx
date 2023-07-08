import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { Home } from "./home";
import { Text } from "react-native";
import { Header } from "../../components/header";
import { Detail } from "./detail";
import { Add } from "./add";

const Stack = createNativeStackNavigator();

export const Subscription = () => {
  return (
    <Stack.Navigator screenOptions={{ header: Header, animation: "fade" }}>
      <Stack.Screen name="subscription-home" component={Home} />
      <Stack.Screen name="subscription-detail" component={Detail} />
      <Stack.Screen name="subscription-add" component={Add} />
    </Stack.Navigator>
  );
};
