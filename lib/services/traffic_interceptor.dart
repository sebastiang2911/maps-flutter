import 'package:dio/dio.dart';
import 'package:maps_app/config/environment.dart';

class TrafficInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'alternatives': true,
      'geometries': 'polyline6',
      'overview': 'simplified',
      'steps': false,
      'access_token': Environment.requiredMapboxAccessToken,
    });

    super.onRequest(options, handler);
  }
}
