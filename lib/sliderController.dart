import 'package:flutter/foundation.dart';

class SliderStateModel extends ChangeNotifier {
  SliderStateModel._privateConstructor();

  static final SliderStateModel instance = SliderStateModel._privateConstructor();

  bool _isSliderOn = false;

  bool get isSliderOn => _isSliderOn;

  setSliderState(bool value) {
    _isSliderOn = value;
    notifyListeners();
  }
}
