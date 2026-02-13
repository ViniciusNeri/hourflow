import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/middleware/auth_middleware.dart';
import 'modules/auth/views/login_page.dart';
import 'modules/auth/views/register_page.dart';
import 'modules/auth/views/verification_page.dart';
import 'modules/home/views/home_page.dart';
import 'modules/home/views/simple_input_page.dart';
import 'modules/home/views/detailed_input_page.dart';

class HourFlowApp extends StatelessWidget {
  final String initialRoute;

  const HourFlowApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HourFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/login', page: () =>  LoginPage()),
        GetPage(name: '/signup', page: () => RegisterPage(), transition: Transition.fadeIn),
        GetPage(name: '/verification', page: () => VerificationPage(), transition: Transition.rightToLeftWithFade),
        
        // Rotas protegidas
        GetPage(
          name: '/home', 
          page: () =>  HomePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/input-simple', 
          page: () => SimpleInputPage(), 
          transition: Transition.rightToLeft,
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/input-detailed', 
          page: () => DetailedInputPage(), 
          transition: Transition.rightToLeft,
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}