
import 'package:flutter/material.dart';

class RouteManager {
  static push(BuildContext context,String url){
    var uri = Uri.parse(url);
    if (uri.scheme != "yyy") {
      return;
    }
    var host = uri.host;
    switch (host){
      case 'page':
        var path = uri.pathSegments.first;
        Navigator.of(context).pushNamed(path,arguments: uri.queryParameters);
    }
  }
}