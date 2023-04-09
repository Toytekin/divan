import 'package:flutter/material.dart';

class RedDecor {
  static BoxDecoration redDekor = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 248, 151, 112),
        Color.fromARGB(255, 255, 131, 82),
        Colors.redAccent,
        Colors.red,
      ],
    ),
  );
}

class GreenDekor {
  static BoxDecoration greenDekor = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 47, 183, 156),
        Color.fromARGB(255, 47, 187, 159),
        Color.fromARGB(255, 31, 174, 146),
        Color.fromARGB(255, 14, 153, 125),
      ],
    ),
  );
}
