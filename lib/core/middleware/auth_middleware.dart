// lib/core/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool isLoggedIn = GetStorage().read('is_logged') ?? false;
    return isLoggedIn ? null : const RouteSettings(name: '/login');
  }
}