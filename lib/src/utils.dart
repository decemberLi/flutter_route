import 'package:flutter/material.dart';

class Utils {
  static String toCamelWords(String word) {
    if (word.isEmpty || (!word.contains("_"))) {
      debugPrint("Input word is empty or not underline");
      return word;
    }
    String key = word;

    int idx = 0;
    int i = 0;
    bool nextWordToUpperCase = false;

    // xxx_ooo_kkk_jjj
    // xxxOooKkkJjj
    while (i < key.length) {
      var ch = key.substring(i, i + 1);
      i++;
      if (ch == '_') {
        nextWordToUpperCase = true;
        continue;
      }
      key = key.replaceRange(
          idx++, idx, nextWordToUpperCase ? ch.toUpperCase() : ch);
      nextWordToUpperCase = false;
    }

    debugPrint("Input word: [$word] , to CamelCase words: [$key]");
    return key.substring(0, idx);
  }

}
