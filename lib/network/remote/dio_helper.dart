import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_social/shared/components/components.dart';
class ShopAppDioHelper {
  static Dio ?dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: "https://student.valuxapps.com/api/",
      headers: {
        "Content-Type": "application/json",
      },
      receiveDataWhenStatusError: true,
    ));
    printMSG("Dio Initiated successfully");
  }

  static Future<Response> get({
    @required String ?url,
    Map<String, dynamic>? query,
    String ?token,
  }) async {
    dio?.options.headers = {
      // "lang": "ar",
      "Content-Type": "application/json",
      "Authorization": token??"",
    };
    return await dio!.get(
      url!,
      queryParameters: query,
    );
  }

  static Future<Response> post({
    @required String? url,
    Map<String, dynamic>? query,
    @required Map<String, dynamic>? data,
    // String lang = language,
    String ?token,
  }) async {
    dio?.options.headers = {
      // "lang": lang!,
      "Content-Type": "application/json",
      "Authorization": token??"",
    };
    return await dio!.post(url!, queryParameters: query, data: data);
  }

  static Future<Response> put({
    @required String ?url,
    Map<String, dynamic>? query,
    @required Map<String, dynamic>? data,
    // String lang = language,
    String? token,
  }) async {
    dio?.options.headers = {
      // "lang": lang,
      "Content-Type": "application/json",
      "Authorization": token??"",
    };
    return await dio!.put(url!, queryParameters: query, data: data);
  }
}
