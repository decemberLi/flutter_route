library yyy_route_annotation;

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

/// page file
class RoutePage {
  const RoutePage();
}

/// main file
class RouteMain {
  const RouteMain();
}

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
          args += '${element.name}:args["${element.name}"],';
        } else {
          args += 'args["${element.name}"],';
        }
      });
      args += ")";
      needArgs = args.length > 2;
    }
    RegExp rule = RegExp(r"[A-Z]");
    var key = element.name
        ?.replaceAllMapped(rule, (Match m) => "_${m[0]?.toLowerCase()}");
    key = key?.replaceFirst("_", "");
    var argsIntro = "";
    if (needArgs) {
      argsIntro = """
   Map<String,dynamic> args = {};
   Map<String,dynamic>? from = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>?;
   if (from != null){
    args = from;
   }
    """;
    }
    _allBody += """ 
"$key": (context){
$argsIntro
   return ${element.name}$args;
}, 
""";
    _allImport.add('import "${buildStep.inputId.uri}";\n');
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
        "Map<String, WidgetBuilder> allRoutes = {$_allBody};";
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
