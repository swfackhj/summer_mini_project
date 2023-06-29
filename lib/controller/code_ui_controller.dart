import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'code_controller.dart';

class CodeUIController extends GetxController{
  final hori = ScrollController().obs;
  final vert = ScrollController().obs;
  final codeCtrl = Get.find<CodeController>();

  RxBool addOn = false.obs;

  RxDouble x = .0.obs;
  RxDouble y = .0.obs;

  @override
  void onInit() {
    super.onInit();
    print(codeCtrl.dashboard.dashboardPosition);
    hori.value.addListener(() {
      codeCtrl.dashboard.setDashboardPosition(Offset(-hori.value.offset,-vert.value.offset));
      x.value = codeCtrl.dashboard.dashboardPosition.dx;
      y.value = codeCtrl.dashboard.dashboardPosition.dy;
    });
    vert.value.addListener(() {
      codeCtrl.dashboard.setDashboardPosition(Offset(-hori.value.offset,-vert.value.offset));
      x.value = codeCtrl.dashboard.dashboardPosition.dx;
      y.value = codeCtrl.dashboard.dashboardPosition.dy;
    });
  }
}