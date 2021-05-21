
import 'package:flutter/material.dart';
import 'package:yyy_route_annotation/route_serializable.dart';

@RoutePage()
class TestPge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

@RouteMain()
void main(){
  runApp(app)
}