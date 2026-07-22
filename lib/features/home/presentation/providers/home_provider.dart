import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeTab(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }
}