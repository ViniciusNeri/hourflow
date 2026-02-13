import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// --- Imports de Configuração e Core ---
import 'app_widget.dart'; // Certifique-se de criar este arquivo com a classe HourFlowApp
import 'core/utils/storage_service.dart';
import 'services/auth_service.dart';
import 'data/datasources/api_datasource.dart';

// --- Imports de Dados (Providers e Repositories) ---
import 'data/providers/user_provider.dart';
import 'data/providers/auth_provider.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/providers/spreadsheet_provider.dart';
import 'data/repositories/spreadsheet_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/spreadsheet_repository.dart';
import 'data/repositories/user_repository.dart';

// --- Imports de Controllers ---
import 'modules/auth/controllers/auth_controller.dart';
import 'modules/home/controllers/settings_controller.dart';
import 'modules/spreadsheet/controllers/spreadsheet_controller.dart';
import 'modules/home/controllers/settings_controller.dart';
import 'modules/home/controllers/home_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  final storage = GetStorage();
  await GetStorage.init();


  final bool isLoggedIn = storage.read('is_logged') ?? false;

  Get.put(StorageService()); 
  Get.put(AuthService()); 
  Get.lazyPut(() => ApiDatasource());   

  Get.lazyPut(() => UserProvider());
  Get.lazyPut(() => UserRepository(Get.find<UserProvider>()));
  Get.put(SettingsController(Get.find<UserRepository>()));

  Get.lazyPut(() => AuthProvider());
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(Get.find<AuthProvider>()));
  Get.put(AuthController(Get.find<AuthRepository>()), permanent: true);
  
  Get.lazyPut(() => SpreadSheetProvider());
  Get.lazyPut<SpreadSheetRepository>(() => SpreadSheetRepositoryImpl(Get.find<SpreadSheetProvider>()));
  Get.put(SpreadSheetController(Get.find<SpreadSheetRepository>()), permanent: true);
  Get.put(HomeController());

  runApp(HourFlowApp(initialRoute: isLoggedIn ? '/home' : '/login'));
}