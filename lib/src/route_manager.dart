import 'package:flutter/material.dart';

/// route to any page use url
/// example:yyy://page/some_page?one_param=1&tow=2
class RouteManager {
  /// push to page
  /// context is current context
  static push(BuildContext context, String url) {
    var uri = Uri.parse(url);
    if (uri.scheme != "yyy") {
      return;
    }
    var host = uri.host;
    switch (host) {
      case 'page':
        var path = uri.pathSegments.first;
        var parameters = uri.queryParameters;
        Map<String, String> args = {};
        parameters.forEach((key, value) {
          var rule = RegExp(r"_(\w)");
          var newKey = key.replaceAllMapped(rule, (m) {
            var value = m[0];
            value = value?.substring(1).toUpperCase();
            return value ?? "";
          });
          args[newKey] = value;
        });
        Navigator.of(context).pushNamed(path, arguments: args);
    }
  }
}
