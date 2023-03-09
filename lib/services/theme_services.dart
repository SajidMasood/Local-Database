import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constant/my_themes.dart';

class ThemeServices extends GetxController{

  final Rx<Color> _color = Colors.white.obs;
  // get Storage store value in form of > {"key": value}
  // more like json file...
  final _box = GetStorage();

  // key
  final _key = 'isDarkMode';

  Color get color => _color.value;
  @override
  void onInit() {
    super.onInit();
    _color.value = _loadThemeFromBox ? Colors.white : Colors.black;
  }

  // save theme value
  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  // fun retun bool value from _box | 1st ? means is there a value
  // 2nd ? means that value | otherwise false
  bool get _loadThemeFromBox => _box.read(_key) ?? false;

  // first time the _box value is false so light theme retuen
  ThemeMode get theme => _loadThemeFromBox ? ThemeMode.dark : ThemeMode.light;

  // another fun to make it dynamic...
  switchTheme() async {
    // add getx lib...
    Get.changeThemeMode(theme);
    _color.value = _loadThemeFromBox ? Colors.white : blackClr;
    await _box.write(_key, !_loadThemeFromBox);
  }
}