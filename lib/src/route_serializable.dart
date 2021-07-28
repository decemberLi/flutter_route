import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'route_annotation.dart';

String _allBody = "";
Set<String> _allImport = {};

/// page generator
class _PageGenerator extends GeneratorForAnnotation<RoutePage> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var args = "()";
    bool needArgs = false;
    if (element is ClassElement) {
      ConstructorElement? constructor;
      try {
        constructor = element.constructors
            .where((element) => element.isDefaultConstructor)
            .first;
      } catch (e) {
        try {
          constructor = element.constructors.first;
        } catch (e) {}
      }
      args = "(";
      constructor?.parameters.forEach((element) {
        if (element.isNamed) {
          args +=
              '${element.name}:typeConvert(args["${element.name}"],${element.type.getDisplayString(withNullability: false)}),';
        } else {
          args +=
              'typeConvert(args["${element.name}"],${element.type.getDisplayString(withNullability: false)}),';
        }
      });
      args += ")";
      needArgs = args.length > 2;
    }
    RegExp rule = RegExp(r"[A-Z]");
    var needLogin = annotation.read("needLogin").boolValue;
    var needAuth = annotation.read("needAuth").boolValue;

    var key = element.name
        ?.replaceAllMapped(rule, (Match m) => "_${m[0]?.toLowerCase()}");
    key = key?.replaceFirst("_", "");
    if(!annotation.read("name").isNull) {
      key = annotation.read("name").stringValue;
    }
    var argsIntro = "";
    if (needArgs) {
      argsIntro = """
   Map<String,dynamic> args = {};
   Map<String,dynamic> from = ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
   if (from != null){
    args = from;
   }""";
    }
    _allBody += """ 
"$key": MRouteAware((context){
$argsIntro
   return ${element.name}$args;
},$needLogin, $needAuth), 
""";
    _allImport.add('import "${buildStep.inputId.uri}";\n');
    _allImport
        .add('import "package:yyy_route_annotation/yyy_route_annotation.dart";');
    return "";
  }
}

/// main generator
class _RouteMainGenerator extends GeneratorForAnnotation<RouteMain> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var importString = _allImport.reduce((value, element) => value + element);
    return 'import "package:flutter/material.dart";\n' +
        importString +
        "\n" +
        "Map<String, WidgetBuilder> routes(){\n"+
        "routeMapping.addAll({$_allBody});\n"+
        "return routeMapping.map((key, value) => MapEntry(key, value.widgetBuilder));"
        "}\n\n";
  }
}

/// build page string
Builder routePageSerializable(BuilderOptions options) {
  _allBody = "";
  _allImport = {};
  return LibraryBuilder(_PageGenerator(), generatedExtension: ".page.dart");
}

/// build main file
Builder routeSerializable(BuilderOptions options) {
  return LibraryBuilder(_RouteMainGenerator(), generatedExtension: ".all.dart");
}
