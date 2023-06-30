import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'code_controller.dart';

class CodeUIController extends GetxController{
  final hori = ScrollController().obs;
  final vert = ScrollController().obs;
  final codeCtrl = Get.find<CodeController>();

  RxBool addOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    print(codeCtrl.dashboard.dashboardPosition);
    hori.value.addListener(() {
      codeCtrl.dashboard.update();
    });
    vert.value.addListener(() {
      codeCtrl.dashboard.update();
    });
  }
}