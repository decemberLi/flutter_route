import 'package:flutter/material.dart';

/// route to any page use url
/// example:yyy://page/some_page?one=1&tow=2
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
        Navigator.of(context).pushNamed(path, arguments: uri.queryParameters);
    }
  }
}
