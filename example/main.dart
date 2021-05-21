import 'package:flutter/material.dart';
import 'package:yyy_route_annotation/route_serializable.dart';
import 'main.all.dart';

@RoutePage()
class TestPge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

@RouteMain()
void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RouteTest",
      routes: allRoutes,
    );
  }
}
