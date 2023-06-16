import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'appstate.dart';
import 'share.dart';
import 'sliderController.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MyAppState.instance.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharePageProcessIsolateController()),
        ChangeNotifierProvider(create: (_) => SliderStateModel.instance),
        // Autres providers nécessaires
      ],
      child: MaterialApp(
        title: 'GeoScan',
        home: HomePage(),
      ),
    );
  }
}

