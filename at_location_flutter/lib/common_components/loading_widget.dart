import 'package:at_location_flutter/service/at_location_notification_listener.dart';
import 'package:flutter/material.dart';

import 'custom_popup_route.dart';

class LoadingDialog {
  LoadingDialog._();

  static LoadingDialog _instance = LoadingDialog._();

  factory LoadingDialog() => _instance;
  bool _showing = false;

  show() {
    if (!_showing) {
      _showing = true;
      AtLocationNotificationListener()
          .navKey
          .currentState
          .push(CustomPopupRoutes(
              pageBuilder: (_, __, ___) {
                print("building loader");
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              barrierDismissible: false))
          .then((_) {});
    }
  }

  hide() {
    print("hide called");
    if (_showing) {
      AtLocationNotificationListener().navKey.currentState.pop();
      _showing = false;
    }
  }
}
