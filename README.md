## Usage

### Add packages to dependencies

Add the package to `dependencies` in your project/packages's `pubspec.yaml`

*  null-safety

``` yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
dependencies:
  yyy_route_annottion: ^0.0.1
``` 

Download with `flutter packages get`

### Add annotation

```dart
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: allRoutes,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

```

### Push
```dart
RouteManager.push(context,"yyy://page/xxx?xx=xx&xx=xx");
```
