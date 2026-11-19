import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controllers/cats_controller.dart';
import 'core/auth_interceptor.dart';
import 'data/cat_api.dart';
import 'data/storage.dart';

final getIt = GetIt.instance;

const apiKey = 'jp03AUJd6Y1zfzyKcyprYOH4Q3qIb6OYSwwiQCaQ';

Future<void> setupDi() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<Storage>(Storage(prefs));

  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.api-ninjas.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.addAll([
      AuthInterceptor(apiKey),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        compact: true,
      ),
    ]);
    return dio;
  });

  getIt.registerLazySingleton<CatApi>(() => CatApi(getIt<Dio>()));
  getIt.registerLazySingleton<CatsController>(
      () => CatsController(getIt<CatApi>(), getIt<Storage>()));
}