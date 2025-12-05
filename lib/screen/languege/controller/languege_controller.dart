import 'dart:ui';
import '/model/languege.dart';
import '/util/preferences_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  RxBool isClickLang = false.obs;
  RxInt selectedLanguageIndex = 0.obs;
  var listLanguege = [
    Languege("Vietnamese", "assets/images/vietnam.png", "vi"),
    // Languege("Hindi", "assets/images/hindi.png", "hi"),
    Languege("Spanish", "assets/images/spanis.png", "es"),
    // Languege("French", "assets/images/french.png", "fr"),
    Languege("German", "assets/images/german.png", "de"),
    Languege("Indonesian", "assets/images/indonesia.png", "id"),
    Languege("Portuguese", "assets/images/portuguese.png", "pt"),
    Languege("English", "assets/images/english.png", "en"),
  ].obs;
  RxString currentLang = PreferencesUtil.getLanguage().obs;
  RxString currentNameLang = "English".obs;
  void checkLanguege() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (PreferencesUtil.isSelectFirstLanguage()) {
        int index =
            listLanguege.indexWhere((lang) => lang.code == currentLang.value);
        if (index != -1) {
          Languege currentLang = listLanguege.removeAt(index);
          listLanguege.insert(0, currentLang);
          selectedLanguageIndex.value = 0;
          currentNameLang.value = listLanguege[0].name;
        }
      }
    });
  }

  String getCurrentLanguage() {
    int index =
        listLanguege.indexWhere((lang) => lang.code == currentLang.value);
    return listLanguege[index].name;
  }

  void selectLanguage(int index) {
    selectedLanguageIndex.value = index;
  }

  void saveLanguage() async {
    await PreferencesUtil.setSelectFirstLanguage();
    Get.updateLocale(Locale(listLanguege[selectedLanguageIndex.value].code));
    currentLang.value = listLanguege[selectedLanguageIndex.value].code;
    currentNameLang.value = listLanguege[selectedLanguageIndex.value].name;
    PreferencesUtil.setLanguage(listLanguege[selectedLanguageIndex.value].code);
  }
}
