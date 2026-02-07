import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'data/datasources/api_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/auth/views/login_page.dart';
import 'modules/home/views/home_page.dart'; // Adicione isso!

void main() {
  // Fazemos a Injeção de Dependências antes do app rodar
  final apiDS = ApiDatasource();
  final authRepo = AuthRepositoryImpl(apiDS);
  
  // Registramos no Antigravity para serem encontrados em qualquer tela
  Get.put<AuthController>(AuthController(authRepo));

  runApp(const HourFlowApp());
}

class HourFlowApp extends StatelessWidget {
  const HourFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HourFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      // Definimos as rotas aqui
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const HomePage()),
      ],
  );
  }
}