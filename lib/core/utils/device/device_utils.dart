import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeviceUtils {
  static bool isIOS() => Platform.isIOS;

  static bool isAndroid() => Platform.isAndroid;

  static bool isPhysicalDevice() {
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width > 600;
}
