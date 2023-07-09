import { View } from "react-native";
import { TextInput, Text, Menu, HelperText } from "react-native-paper";
import { globalStyles } from "../styles";
import { useRef, useState } from "react";
import { TimeExtension } from "../util/timeExtension";

type Props = {
  value: string;
  onChangeText: (value: string) => void;
};

function getDefaultUnit(value: string) {
  if (!value.length) {
    return "天";
  }

  if (value[value.length - 1] === "d") {
    return "天";
  } else if (value[value.length - 1] === "m") {
    return "月";
  } else {
    return "年";
  }
}

export const TimeExtensionInput = ({ value, onChangeText }: Props) => {
  const [unit, setUnit] = useState<"天" | "月" | "年">(getDefaultUnit(value));
  const [showMenu, setShowMenu] = useState(false);
  const valueRef = useRef(value);

  const handleChangeText = (value: string, usingUnit = unit) => {
    if (usingUnit === "天") {
      onChangeText(value + "d");
    } else if (usingUnit === "月") {
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
                  title="天"
                  onPress={() => {
                    setUnit("天");
                    setShowMenu(false);
                    handleChangeText(
                      new TimeExtension(valueRef.current).unitValue.toString(),
                      "天"
                    );
                  }}
                />
                <Menu.Item
                  title="月"
                  onPress={() => {
                    setUnit("月");
                    setShowMenu(false);
                    handleChangeText(
                      new TimeExtension(valueRef.current).unitValue.toString(),
                      "月"
                    );
                  }}
                />
                <Menu.Item
                  title="年"
                  onPress={() => {
                    setUnit("年");
                    setShowMenu(false);
                    handleChangeText(
                      new TimeExtension(valueRef.current).unitValue.toString(),
                      "年"
                    );
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
        {unit === "月" && "每月将折算成31天"}
        {unit === "年" && "每年将折算成365天"}
      </HelperText>
    </View>
  );
};
