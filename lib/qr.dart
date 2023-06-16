import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appstate.dart';
import 'follow.dart';

// Classe QRScan
class QRScanPage extends StatelessWidget {
  const QRScanPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QRScanController(),
      child: const QRScanProcess(),
    );
  }
}

class QRScanProcess extends StatelessWidget {
  const QRScanProcess({Key? key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<QRScanController>(context);
    final txtController = TextEditingController();
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter, // Alignement des widgets enfants au centre
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () async {
                  await Permission.camera.request();
                  controller.scanRes = await scanner.scan();
                  controller.printScan(controller.scanRes);
                  // Code pour ouvrir la caméra et commencer la numérisation
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FollowPage()),
                  );
                },
                child: Text("Utiliser un QR code"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextField(
                controller: txtController,
                decoration: InputDecoration(
                  labelText: 'Entrez un lien',
                  hintText: 'Lien',
                  prefixIcon: Icon(Icons.link),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ElevatedButton(
                onPressed: () {
                  controller.printScan(txtController.value.text);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FollowPage()),
                  );
                },
                child: Text("Utiliser un lien"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QRScanController extends ChangeNotifier {
  MyAppState appState = MyAppState.instance;
  String? scanRes = "";

  void printScan(String? scan) {
    appState.subscribeChannel(scan);
  }
}
