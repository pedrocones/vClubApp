import 'package:flutter/foundation.dart';

class LocationAppState extends ChangeNotifier {
  String? _locationKey;

  String? get locationKey => _locationKey;

  /// Modifies the global location key scope and updates listening widgets across the app
  void updateGlobalLocationKey(String? newKey) {
    if (_locationKey != newKey) {
      _locationKey = newKey;
      notifyListeners();
    }
  }
}
