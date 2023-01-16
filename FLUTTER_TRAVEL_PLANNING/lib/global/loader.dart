import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'color.dart';

class AppLoader {
  static show() {
    return EasyLoading.show(status: 'Please wait...');
  }

  static hide() {
    EasyLoading.dismiss();
  }

  static showError(msg) {
    EasyLoading.showError(msg);
  }

  static showSuccess(msg) {
    EasyLoading.showSuccess(msg);
  }

  static showInfo(msg) {
    EasyLoading.showInfo(msg);
  }

  static loaderWaitPage() {
    return Material(
      color: AppColors.color.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(AppColors.bgColor),
        ),
      ),
    );
  }
}
