import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfig{
  static FirebaseRemoteConfig? _instance;

  static FirebaseRemoteConfig get instance {
    return _instance ??= FirebaseRemoteConfig();
  }

  static bool get isSupported =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  RemoteConfig? config;

  FirebaseRemoteConfig() {
    if (isSupported) {
      config = RemoteConfig.instance;
    }
  }

  Future<bool?> fetchAndActivate() async {
    if (config != null) {
      return config!.fetchAndActivate();
    } else {
      return null;
    }
  }
}