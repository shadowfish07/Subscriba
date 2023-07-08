import { View } from "react-native";
import { TextInput, Text, Menu, HelperText } from "react-native-paper";
import { globalStyles } from "../styles";
import { useState } from "react";

type Props = {
  value: string;
  onChangeText: (value: string) => void;
};

function getDefaultUnit(value: string) {
  if (!value.length) {
    return "日";
  }

  if (value[value.length - 1] === "d") {
    return "日";
  } else if (value[value.length - 1] === "m") {
    return "月";
  } else {
    return "年";
  }
}

export const TimeExtensionInput = ({ value, onChangeText }: Props) => {
  const [unit, setUnit] = useState<"日" | "月" | "年">(getDefaultUnit(value));
  const [showMenu, setShowMenu] = useState(false);

  const handleChangeText = (value: string) => {
    if (unit === "日") {
      onChangeText(value + "d");
    } else if (unit === "月") {
      onChangeText(value + "m");
    } else {
      onChangeText(value + "y");
    }
  };

  return (
    <View>
      <TextInput
        label="有效时间"
        mode="outlined"
        inputMode="numeric"
        value={value.slice(0, value.length - 1)}
        onChangeText={handleChangeText}
        style={globalStyles.textInput}
        right={
          <TextInput.Icon
            forceTextInputFocus={false}
            onPress={() => setShowMenu(true)}
            icon={() => (
              <Menu
                visible={showMenu}
                onDismiss={() => setShowMenu(false)}
                anchor={<Text>{unit}</Text>}
                style={{ width: 50 }}
              >
                <Menu.Item
                  title="日"
                  onPress={() => {
                    setUnit("日");
                    setShowMenu(false);
                  }}
                />
                <Menu.Item
                  title="月"
                  onPress={() => {
                    setUnit("月");
                    setShowMenu(false);
                  }}
                />
                <Menu.Item
                  title="年"
                  onPress={() => {
                    setUnit("年");
                    setShowMenu(false);
                  }}
                />
              </Menu>
            )}
          />
        }
      />
      <HelperText
        type="info"
        visible={["月", "年"].includes(unit)}
        style={{ marginTop: -10 }}
      >
        {unit === "月" && "每月将折算成31日"}
        {unit === "年" && "每年将折算成365日"}
      </HelperText>
    </View>
  );
};
