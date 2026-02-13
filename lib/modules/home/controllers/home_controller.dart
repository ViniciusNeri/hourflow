import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../views/widgets/welcome_bottom_sheet.dart';
import 'package:get_storage/get_storage.dart'; 

enum ProcessMode { simple, detailed }

class HomeController extends GetxController {
  var processMode = ProcessMode.simple.obs;
  final _cache = GetStorage(); 

  void setMode(ProcessMode mode) => processMode.value = mode;

  @override
  void onReady() {
    super.onReady();
    _checkFirstAccess();
  }

  void handleNavigation() {
    if (processMode.value == ProcessMode.simple) {
      Get.toNamed('/input-simple');
    } else {
      Get.toNamed('/input-detailed');
    }
  }

  void _checkFirstAccess() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (Get.currentRoute == '/home') {
        bool showWelcome = _cache.read('show_welcome') ?? true;
        if (showWelcome) {
          _showWelcomeSheet();
          _cache.write('show_welcome', false);
        }
      }
    });
  }

  void _showWelcomeSheet() {
    Get.bottomSheet(
      const WelcomeBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Para permitir bordas arredondadas
    );
  }
}