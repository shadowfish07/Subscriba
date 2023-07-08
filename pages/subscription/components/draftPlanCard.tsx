import { Card, Button } from "react-native-paper";
import { globalStyles } from "../../../styles";

type Props = {
  title: string;
  children: React.ReactNode;
  showSaveButton?: boolean;
  onSave?: () => void;
  onCancel?: () => void;
};
export const DraftPlanCard = ({
  title,
  children,
  showSaveButton,
  onSave,
  onCancel,
}: Props) => {
  return (
    <Card style={globalStyles.card}>
      <Card.Title title={title} />
      <Card.Content>{children}</Card.Content>
      <Card.Actions style={{ marginTop: 20 }}>
        <Button mode="text" onPress={() => onCancel()}>
          删除
        </Button>
        {showSaveButton && (
          <Button mode="contained-tonal" onPress={() => onSave()}>
            保存
          </Button>
        )}
      </Card.Actions>
    </Card>
  );
};
