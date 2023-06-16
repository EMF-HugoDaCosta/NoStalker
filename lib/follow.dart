import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appstate.dart';
import 'share.dart';
import 'sliderController.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:pubnub/pubnub.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowPage extends StatefulWidget {
  const FollowPage();

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPage> {

  Timer? messageTimer;
  MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior();


  @override
  void initState() {
    super.initState();
    startMessageTimer();
  }

  @override
  void dispose() {
    stopMessageTimer();
    super.dispose();
  }

  void startMessageTimer() async {
    stopMessageTimer();

    var status = await Permission.location.request();

    if (status.isGranted) {
      messageTimer = Timer.periodic(Duration(seconds: 5), (_) async {
        final sliderState =
            SliderStateModel.instance;
        if (sliderState.isSliderOn) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );

          final data = {
            'latitude': position.latitude,
            'longitude': position.longitude,
          };

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String channel = prefs.getString('uuid') ?? 'none';
          final appstate = MyAppState.instance;
          final publishResult = await appstate.pubnub.publish(
             channel,
             data,
          );
        }
        setState(() {});
      });
    } else {
      print('Permission de localisation refusée');
    }
  }

  void stopMessageTimer() {
    messageTimer?.cancel();
    messageTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final sharePageController =
    Provider.of<SharePageProcessIsolateController>(context);
    final sliderState = Provider.of<SliderStateModel>(context);
    final appstate = MyAppState.instance;

    return Scaffold(
      body: ListView.separated(
        itemCount: appstate.textFieldValues.length + 2,
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AppBar();
          } else if (index == 1) {
            return SfMaps(
              layers: <MapLayer>[
                MapTileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  initialZoomLevel: 1,
                  initialFocalLatLng: MapLatLng(46.7938614, 7.1567384),
                  zoomPanBehavior: _zoomPanBehavior,
                  initialMarkersCount: appstate.dataMaps.length,
                  markerBuilder: (BuildContext context, int index) {
                    return MapMarker(
                      latitude: appstate.dataMaps[index].latitude,
                      longitude: appstate.dataMaps[index].longitude,
                      child: Icon(Icons.location_on, color: Colors.red),
                    );
                  },
                  controller: appstate.controller,
                ),
              ],
            );
          } else if (index <= appstate.textFieldValues.length + 1) {
            return Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                appstate.textFieldValues[index - 2],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }
}
