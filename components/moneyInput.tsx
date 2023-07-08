import { TextInput, TouchableRipple, Text } from "react-native-paper";
import { globalStyles } from "../styles";
import { View } from "react-native";

type Props = {
  label: string;
  value: string;
  onChangeText: (value: string) => void;
  currency?: string;
};
export const MoneyInput = ({
  label,
  value,
  onChangeText,
  currency = "¥",
}: Props) => {
  return (
    <View>
      <TextInput
        label={label}
        mode="outlined"
        value={value.slice(1)}
        onChangeText={(value) => onChangeText(currency + value)}
        style={globalStyles.textInput}
        left={
          <TextInput.Icon
            forceTextInputFocus={false}
            icon={() => <Text>{currency}</Text>}
          />
        }
        inputMode="numeric"
      />
    </View>
  );
};
