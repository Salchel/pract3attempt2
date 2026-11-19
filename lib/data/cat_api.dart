import 'package:dio/dio.dart';
import '../models/cat.dart';

class CatApi {
  final Dio _dio;
  CatApi(this._dio);

  Future<List<Cat>> searchByName(String name) async {
    final res = await _dio.get('/cats', queryParameters: {'name': name});
    final list = res.data as List;
    return list.map((e) => Cat.fromJson(e as Map<String, dynamic>)).toList();
  }
}