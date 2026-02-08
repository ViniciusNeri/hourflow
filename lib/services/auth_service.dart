import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _userId = ''.obs;

  // Getter para acessar o ID em qualquer lugar
  String get userId => _userId.value;

  @override
  void onInit() {
    super.onInit();
    // Ao iniciar, tenta carregar o ID que foi salvo anteriormente
    _userId.value = _storage.read('user_id') ?? '';
  }

  // Função para salvar o ID após o login bem-sucedido
  void saveUserId(String id) {
    _userId.value = id;
    _storage.write('user_id', id);
  }

  // Função para logout
  void logout() {
    _storage.remove('user_id');
    _userId.value = '';
  }
}