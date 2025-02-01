import 'package:flutter/material.dart';

class ObjectSelectionProvider extends ChangeNotifier {
  String? _selectedObject;

  String? get selectedObject => _selectedObject;

  void selectObject(String object) {
    if (_selectedObject == object) {
      _selectedObject = null;
    } else {
      _selectedObject = object;
    }
    notifyListeners();
  }

  void resetSelection() {
    _selectedObject = null;
    notifyListeners();
  }
}
