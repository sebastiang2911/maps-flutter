import 'package:dio/dio.dart';
import 'package:maps_app/config/environment.dart';

class PlacesInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({
      'access_token': Environment.requiredMapboxAccessToken,
      'language': 'es',
    });
    super.onRequest(options, handler);
  }
}
