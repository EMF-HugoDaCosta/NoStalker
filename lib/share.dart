import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'appstate.dart';
import 'package:flutter/services.dart';
import 'sliderController.dart';

class SharePage extends StatelessWidget {
  const SharePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SharePageProcessIsolateController(),
      child: const SharePageProcess(),
    );
  }
}

class SharePageProcess extends StatelessWidget {
  const SharePageProcess({Key? key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SharePageProcessIsolateController>(context);
    final sliderState = Provider.of<SliderStateModel>(context); // Accédez à l'instance unique de SliderStateModel

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200,
            child: QrImageView(data: controller.getUUID()),
          ),
          ElevatedButton(
            onPressed: () {
              String textToCopy = controller.getUUID();
              controller.copyToClipboard(textToCopy);
            },
            child: Text('Copier le lien'),
          ),
          Consumer<SliderStateModel>( // Utilisez Consumer<SliderStateModel> au lieu de Consumer<SharePageProcessIsolateController>
            builder: (context, model, child) { // Utilisez le modèle de SliderStateModel
              return SwitchListTile(
                title: const Text('Partage activé'),
                value: model.isSliderOn, // Utilisez la valeur du modèle de SliderStateModel
                onChanged: (value) {
                  model.setSliderState(value); // Mettez à jour l'état du modèle de SliderStateModel
                  print(model.isSliderOn); // Affichez la valeur actuelle du slider
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class SharePageProcessIsolateController extends ChangeNotifier {
  final appsate = MyAppState.instance;
  String getUUID(){
    return appsate.getUUID();
  }
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
