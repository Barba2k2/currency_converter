import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class FeatureManager {
  static final remoteConfig = FirebaseRemoteConfig.instance;

  static bool isFeatureEnabled(String featureKey) {
    return remoteConfig.getBool(featureKey);
  }

  static dynamic getFeatureConfig(String featureKey) {
    return json.decode(remoteConfig.getString(featureKey));
  }
}
