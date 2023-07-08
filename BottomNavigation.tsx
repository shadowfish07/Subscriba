import * as React from "react";
import {
  BottomNavigation as PaperBottomNavigation,
  Text,
} from "react-native-paper";
import { Subscription } from "./pages/subscription";
import { SubscriptionItem } from "./components/subscriptionItem";

const MusicRoute = () => <SubscriptionItem />;

const AlbumsRoute = () => <Text>Albums</Text>;

const RecentsRoute = () => <Text>Recents</Text>;

const NotificationsRoute = () => <Text>Notifications</Text>;

const BottomNavigation = () => {
  const [index, setIndex] = React.useState(0);
  const [routes] = React.useState([
    {
      key: "home",
      title: "主页",
      focusedIcon: "home",
      unfocusedIcon: "home-outline",
    },
    { key: "albums", title: "Albums", focusedIcon: "album" },
    // { key: "recents", title: "Recents", focusedIcon: "history" },
    // {
    //   key: "notifications",
    //   title: "Notifications",
    //   focusedIcon: "bell",
    //   unfocusedIcon: "bell-outline",
    // },
  ]);

  const renderScene = PaperBottomNavigation.SceneMap({
    home: Subscription,
    albums: AlbumsRoute,
    // recents: RecentsRoute,
    // notifications: NotificationsRoute,
  });

  return (
    <PaperBottomNavigation
      navigationState={{ index, routes }}
      onIndexChange={setIndex}
      renderScene={renderScene}
    />
  );
};

export default BottomNavigation;
