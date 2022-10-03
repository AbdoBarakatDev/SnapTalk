import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class AppDioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://student.valuxapps.com/api/",
      headers: {
        "Content-Type": "application/json",
      },
      receiveDataWhenStatusError: true,
    ));
    if (kDebugMode) {
      print("Dio Initiated successfully");
    }
  }

  static Future<Response> get({
    required String url,
    required Map<String, dynamic> query,
    required String lang,
    required String token,
  }) async {
    dio?.options.headers = {
      "lang": lang,
      "Content-Type": "application/json",
      "Authorization": token,
    };
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> post({
    required String? url,
    // Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    dio?.options.headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key= AAAAoC1u5C4:APA91bHWhqxDd4Vx1aG33hETHCoVaXlijCOs7sTweNNRpoY6uMd2dE9pXe6UhqOqhEJwAb0NXuVW2sPSPgN479p_wO1PCGfikdU4mHY6GxJng0F-iR46_6fNF3UowU7RMf21s11jLckU",
    };
    return await dio!.post(url!, data: data);
  }

  static Future<Response> put({
    required String? url,
    required Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    // required String? lang,
    required String? token,
  }) async {
    dio?.options.headers = {
      // "lang": lang!,
      "Content-Type": "application/json",
      "Authorization": token!,
    };
    return await dio!.put(url!, queryParameters: query, data: data);
  }
}
