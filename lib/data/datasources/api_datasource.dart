import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';

class ApiDatasource {
  late final Dio _dio;

  ApiDatasource() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adicionaremos os Interceptors (Log e Auth) aqui em breve!
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) {
          // Aqui tratamos o erro do Render estar "dormindo"
          if (e.type == DioExceptionType.connectionTimeout) {
            print("O servidor está acordando... tente novamente em instantes.");
          }
          return handler.next(e);
        },
      ),
    );
  }

  // Getter para acessar o Dio de forma segura
  Dio get httpClient => _dio;
}