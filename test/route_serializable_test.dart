import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yyy_route_annotation/route_serializable.dart';

@RoutePage()
class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

@RouteMain()
void main() {
  test('test', () {

  });
}
