## yyy_route_annotation

Provide a route generator to create route map quickly by annotations.

When you receive a notification or deep link, you can use url to jump to each page.

## Usage

### Add packages to dependencies

Add the package to `dependencies` in your project/packages's `pubspec.yaml`

*  null-safety

``` yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
dependencies:
  yyy_route_annotation: ^0.0.2
dev_dependencies:
  build_runner: ^2.0.0
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

```

```
flutter packages pub run build_runner build
```

```dart
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
RouteManager.push(context,"yyy://page/one_page?param_one=xx&two=xx");
```
url params use '_' and dart class params use 'Camel Case'.
