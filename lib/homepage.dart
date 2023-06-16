import 'package:flutter/material.dart';
import 'follow.dart';
import 'share.dart';
import 'qr.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('NoStalker'),
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            QRScanPage(),
            SharePage(),
            FollowPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.plus_one),
              label: "S'abonner",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care),
              label: 'Partager sa géolocalisation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: 'Suivre la géolocalistion',
            ),
          ],
        ),
      ),
    );
  }
}
