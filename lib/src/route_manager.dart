import 'package:flutter/material.dart';
import 'package:yyy_route_annotation/src/utils.dart';

import '../yyy_route_annotation.dart';

///
/// Custom interceptor
///
typedef RouteInterceptor = Future<dynamic> Function(BuildContext context,String path);

///
/// User Loginning status check
///
typedef LoginInterceptor = Future<bool> Function(BuildContext context);

///
/// User auth check interceptor, True is exec push operator,\
/// otherwise will be break.
///
typedef AuthInterceptor = Future<bool> Function(BuildContext context);

class RouteResult {
  bool status;

  dynamic? result;

  RouteResult(this.status);

  factory RouteResult.failure() => RouteResult(false)..result = null;

  factory RouteResult.success(dynamic rest) => RouteResult(true)..result = rest;
}

/// route to any page use url
/// example:yyy://page/some_page?one_param=1&tow=2
class RouteManager {
  static LoginInterceptor _loginInterceptor = (ctx) {
    return Future.value(false);
  };

  static AuthInterceptor _authenticInterceptor = (ctx) {
    return Future.value(false);
  };

  static RouteInterceptor _routeInterceptor = (ctx,path) {
    return Future.value(true);
  };

  static void commonLoginInterceptor(LoginInterceptor interceptor) {
    _loginInterceptor = interceptor;
  }

  static void commonAuthInterceptor(AuthInterceptor interceptor) {
    _authenticInterceptor = interceptor;
  }

  static void routeInterceptor(RouteInterceptor interceptor) {
    _routeInterceptor = interceptor;
  }

  /// push to page
  /// context is current context
  static Future<RouteResult> push(BuildContext context, String url,
      {RouteInterceptor? routeInterceptor,bool replace = false}) async {

    var uri = Uri.parse(url);
    if (uri.scheme != "yyy") {
      return RouteResult.failure();
    }
    var host = uri.host;
    switch (host) {
      case 'page':
        var path = uri.pathSegments.first;
        var parameters = uri.queryParameters;
        Map<String, String> args = {};
        parameters.forEach((key, value) {
          args[Utils.toCamelWords(key)] = value;
        });
        if (!routeMapping.containsKey(path)) {
          debugPrint(
              "The path: [$path] not exists in routeMapping. Plage check @RoutePage");
          return RouteResult.failure();
        }

        if (routeMapping[path]!.needLogin &&
            (!await _loginInterceptor(context))) {
          debugPrint("This path: [$path] need user logineed.");
          return RouteResult.failure();
        }

        if (routeMapping[path]!.needAuth &&
            (!await _authenticInterceptor(context))) {
          debugPrint(
              "This path: [$path] need user info Authentication status passed.");
          return RouteResult.failure();
        }

        if (routeInterceptor == null){
          routeInterceptor = _routeInterceptor;
        }

        /// true is continue exec push logic, otherwise will be break
        if (await routeInterceptor(context,path)) {
          if (replace){
            return _replace(context, path, args);
          }else{
            return _doPush(context, path, args);
          }
        }
    }
    return RouteResult.failure();
  }

  static Future<RouteResult> _doPush(
      BuildContext context, String path, Map<String, String> args) async {
    var result = await Navigator.of(context).pushNamed(path, arguments: args);
    return RouteResult.success(result);
  }

  static Future<RouteResult> _replace(
      BuildContext context, String path, Map<String, String> args) async {
    var result = await Navigator.of(context).pushNamedAndRemoveUntil(path, (route) => false , arguments: args);
    return RouteResult.success(result);
  }
}
