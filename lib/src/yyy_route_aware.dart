import 'package:flutter/material.dart';

class MRouteAware {
  final bool needLogin;
  final bool needAuth;
  final WidgetBuilder widgetBuilder;

  MRouteAware(this.widgetBuilder, this.needLogin, this.needAuth);
}

Map<String, MRouteAware> routeMapping = {};


