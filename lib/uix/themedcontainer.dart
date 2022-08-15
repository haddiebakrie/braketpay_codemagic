import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContainerBackgroundDecoration extends BoxDecoration {
  @override
  final BorderRadius borderRadius = const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20));
  @override
  final color = Get.isDarkMode ? Color.fromARGB(255, 5, 1, 18) : Colors.white;
  
  
}

class ContainerDecoration extends BoxDecoration {
  @override
  final BorderRadius borderRadius = BorderRadius.circular(20);
  @override
  final color = Get.isDarkMode ? Color.fromARGB(255, 42, 42, 59).withOpacity(0.5) : Colors.white;
  @override
  final List<BoxShadow> boxShadow = [
    BoxShadow(
      color:  Get.isDarkMode ? Colors.black.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
      spreadRadius: 3,
      blurRadius: 10,
      offset: const Offset(0, 0),
    )
                        ];
  @override
  final foregroundColor = Colors.black;
}

Color NeutralButton = Get.isDarkMode ? Get.theme.primaryColor : Colors.black;
Color adaptiveColor = Get.textTheme.bodyLarge?.color??Colors.grey;
Color ThemedBackgroundColor = Get.isDarkMode ? Colors.black : Colors.white;