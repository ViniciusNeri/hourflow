import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'services/auth_service.dart';
import 'data/providers/user_provider.dart';
import 'data/repositories/user_repository.dart';
import 'modules/home/controllers/settings_controller.dart';
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/home/views/home_page.dart';
import 'modules/auth/views/login_page.dart';
import 'modules/home/views/simple_input_page.dart';
import 'modules/home/views/detailed_input_page.dart';
import 'data/datasources/api_datasource.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/providers/spreadsheet_provider.dart';
import 'data/repositories/spreadsheet_repository.dart';
import 'modules/home/controllers/process_controller.dart';
import 'modules/spreadsheet/controllers/spreadsheet_controller.dart';

void main() async {
  // 1. Garante a inicialização dos bindings do Flutter
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializa o armazenamento local
  await GetStorage.init();

  // 3. Configura as dependências usando GetX
  Get.put(AuthService()); 
  Get.lazyPut(() => UserProvider());
  Get.lazyPut(() => UserRepository(Get.find<UserProvider>()));
  Get.lazyPut(() => ApiDatasource());  
  Get.put(SettingsController(Get.find<UserRepository>()));
  Get.lazyPut(() => AuthRepositoryImpl(Get.find<ApiDatasource>()));
  //Get.lazyPut(() => AuthController(Get.find<AuthRepositoryImpl>()), permanent: true);
  Get.put(AuthController(Get.find<AuthRepositoryImpl>()), permanent: true);
  Get.lazyPut(() => SpreadSheetProvider());
  Get.lazyPut(() => SpreadSheetRepository(Get.find<SpreadSheetProvider>()));
  //Get.put(() => SpreadSheetController(Get.find<SpreadSheetRepository>()), permanent: true);
  Get.put(SpreadSheetController(Get.find<SpreadSheetRepository>()), permanent: true);

  runApp(const HourFlowApp());
}

class HourFlowApp extends StatelessWidget {
  const HourFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HourFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()), // Removido o 'const' se der erro
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(
          name: '/input-simple', 
          page: () => SimpleInputPage(), 
          transition: Transition.rightToLeft
        ),
        GetPage(
          name: '/input-detailed', 
          page: () => DetailedInputPage(), 
          transition: Transition.rightToLeft
        ),
      ],
    );
  }
}