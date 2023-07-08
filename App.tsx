import {
  PaperProvider,
  MD3DarkTheme,
  adaptNavigationTheme,
} from "react-native-paper";
import BottomNavigation from "./BottomNavigation";
import { StatusBar } from "expo-status-bar";
import {
  NavigationContainer,
  DarkTheme as NavigationDarkTheme,
  DefaultTheme as NavigationDefaultTheme,
} from "@react-navigation/native";
import { registerTranslation } from "react-native-paper-dates";
import { useDatabaseStore } from "./store/useDatabaseStore";
import { useEffect } from "react";
registerTranslation("zh", {
  save: "保存",
  selectSingle: "选择日期",
  selectMultiple: "选择多个日期",
  selectRange: "选择区间",
  notAccordingToDateFormat: (inputFormat) => `日期格式需为 ${inputFormat}`,
  mustBeHigherThan: (date) => `必须要晚于 ${date}`,
  mustBeLowerThan: (date) => `必须要早于 ${date}`,
  mustBeBetween: (startDate, endDate) =>
    `必须在 ${startDate} - ${endDate} 之间`,
  dateIsDisabled: "该日期不可用",
  previous: "上一个",
  next: "下一个",
  typeInDate: "输入日期",
  pickDateFromCalendar: "从日历选择日期",
  close: "关闭",
});

const { LightTheme, DarkTheme } = adaptNavigationTheme({
  reactNavigationLight: NavigationDefaultTheme,
  reactNavigationDark: NavigationDarkTheme,
});
const CombinedDarkTheme = {
  ...MD3DarkTheme,
  ...DarkTheme,
  colors: {
    ...MD3DarkTheme.colors,
    ...DarkTheme.colors,
  },
};

export default function App() {
  const openDatabase = useDatabaseStore((store) => store.openDatabase);

  useEffect(() => {
    openDatabase();
  }, []);

  return (
    <PaperProvider theme={MD3DarkTheme}>
      <NavigationContainer theme={CombinedDarkTheme}>
        <StatusBar style="dark" backgroundColor="#1c1b1f" />
        <BottomNavigation />
      </NavigationContainer>
    </PaperProvider>
  );
}
