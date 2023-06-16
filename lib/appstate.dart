import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pubnub/pubnub.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'NotificationService.dart';
import 'package:shake/shake.dart';

import 'sliderController.dart';

class MyAppState {
  MyAppState._privateConstructor();

  static final MyAppState instance = MyAppState._privateConstructor();
  List<String> textFieldValues = [];

  var uuid = "none";
  String chanel = "none";
  late MapTileLayerController controller = MapTileLayerController();
  late List<Model> dataMaps = <Model>[];

  final pubnub = PubNub(
      defaultKeyset: Keyset(
          subscribeKey: 'sub-c-ac8f712f-a142-4ae9-8a80-6396e651fbd7',
          publishKey: 'pub-c-30938b91-e853-4098-9375-b62d16e2803f',
          uuid:
              UUID('sec-c-ODU4OWJkOGItZjBiZS00OWEzLWFiNjQtOWZhY2M3OWFlMWVm')));

  void subscribeChannel(scan) {
    chanel = scan;
    var sub = pubnub.subscribe(channels: {chanel!});
    //send("un utilisateur c'est connecté");
    sub.messages.listen(
      (event) => show(event),
    );
  }

  void show(Envelope envelope) {
    if (envelope.payload == "shake") {
      final NotificationService notificationService;
      notificationService = NotificationService();
      notificationService.initializePlatformNotifications();
      notificationService.showLocalNotification(
          id: 1,
          title: "Sheik Alerte",
          body: "",
          payload: 'Hurray Its the payload');
    } else {
      String formatedData = "Latitude: " +
          envelope.payload['latitude'].toString() +
          " Longitude: " +
          envelope.payload['longitude'].toString();
      dataMaps.add(Model(envelope.payload['latitude'] , envelope.payload['longitude']));
      textFieldValues.insert(0, formatedData);
      controller.insertMarker(dataMaps.length-1);
      controller.updateMarkers([dataMaps.length-1]);
    }
  }

  void send(String messgae) {
    pubnub.publish(chanel!, messgae);
  }

  String getUUID() {
    return uuid;
  }

  void init() async {
    //Check UUID in shared preferences and generate if not found
    SharedPreferences prefs = await SharedPreferences.getInstance();
    uuid = await prefs.getString('uuid') ?? "none";
    if (uuid == "none") {
      uuid = Uuid().v4();
    }
    prefs.setString('uuid', uuid);

    //Subscribe to channel
    var subscription = MyAppState.instance.pubnub.subscribe(channels: {uuid});
    subscription.messages.listen((envelope) {
      //Local notification
      if (envelope.payload == "shake") {
        final NotificationService notificationService;
        notificationService = NotificationService();
        notificationService.initializePlatformNotifications();
        notificationService.showLocalNotification(
            id: 1,
            title: "Sheik Alerte",
            body: "",
            payload: 'Hurray Its the payload');
      } else {
        String formatedData = "Latitude: " +
            envelope.payload['latitude'].toString() +
            " Longitude: " +
            envelope.payload['longitude'].toString();
            dataMaps.add(Model(envelope.payload['latitude'],envelope.payload['longitude']));
            print(dataMaps[dataMaps.length-1].latitude.toString() + " " + dataMaps[dataMaps.length-1].longitude.toString());
        textFieldValues.insert(0, formatedData);
        controller.insertMarker(dataMaps.length-1);
        controller.updateMarkers([dataMaps.length-1]);
      }
    });

    //Shake handler
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        textFieldValues.insert(0, "Sheik Alerte");
        final sliderState = SliderStateModel.instance;
        if(sliderState.isSliderOn){
          final NotificationService notificationService;
          notificationService = NotificationService();
          notificationService.initializePlatformNotifications();
          notificationService.showLocalNotification(
              id: 1,
              title: "Sheik Alerte",
              body: "",
              payload: 'Hurray Its the payload');
          pubnub.publish(uuid, "shake");
        }else{
          final NotificationService notificationService;
          notificationService = NotificationService();
          notificationService.initializePlatformNotifications();
          notificationService.showLocalNotification(
              id: 1,
              title: "Turn on sharing",
              body: "",
              payload: 'Hurray Its the payload');
        }

      },
      shakeThresholdGravity: 4,
    );
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    print("onDidReceiveNotificationResponse");
  }
}


class Model {
  const Model(this.latitude, this.longitude);

  final double latitude;
  final double longitude;

}
