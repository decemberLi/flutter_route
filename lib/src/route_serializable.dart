import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'route_annotation.dart';

String _allBody = "";
Set<String> _allImport = {};
String _allInterface = "";

/// page generator
class _PageGenerator extends GeneratorForAnnotation<RoutePage> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    var args = "()";
    var interfaceArgs="()";
    bool needArgs = false;
    Map<String, dynamic> paramMap = {};
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
      interfaceArgs="(";
      bool hasNameArg = false;
      String namedArg = "";
      constructor?.parameters.forEach((element) {
        if (element.isNamed) {
          args +=
          '${element.name}:typeConvert(args["${element.name}"],${element.type.getDisplayString(withNullability: false)}),';
          namedArg+= "${element.type.getDisplayString(withNullability: true)} ${element.name},";
          hasNameArg = true;
        } else {
          args +=
          'typeConvert(args["${element.name}"],${element.type.getDisplayString(withNullability: false)}),';
          interfaceArgs+= "${element.type.getDisplayString(withNullability: true)} ${element.name},";
        }
        paramMap['${element.name}'] = '${element.name}';
      });
      if(hasNameArg){
        interfaceArgs+="{$namedArg}";
      }
      interfaceArgs+=")";
      args += ")";
      needArgs = args.length > 2;
    }
    RegExp rule = RegExp(r"[A-Z]");
    var needLogin = annotation.read("needLogin").boolValue;
    var needAuth = annotation.read("needAuth").boolValue;

    var key = element.name
        ?.replaceAllMapped(rule, (Match m) => "_${m[0]?.toLowerCase()}");
    key = key?.replaceFirst("_", "");
    String urlKey = key??"";
    if(!annotation.read("name").isNull) {
      key = annotation.read("name").stringValue;
      urlKey = key.replaceAllMapped(rule, (Match m) => "_${m[0]?.toLowerCase()}");
    }
    String pMap= """ 
    Map<String,dynamic> param = <String,dynamic>{
    """;
    paramMap.forEach((oKey, oValue) {
      pMap += '\n$oKey:$oValue,';
    });
    pMap += "\n};";

    var argsIntro = "";
    if (needArgs) {
      argsIntro = """
   Map<String,dynamic> args = {};
   Map<String,dynamic> from = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
   if (from != null){
    args = from;
   }""";
    }
    _allBody += """ 
"$urlKey": MRouteAware((context){
$argsIntro
   return ${element.name}$args;
},$needLogin, $needAuth), 
""";
    _allInterface += """ 
    static $key$interfaceArgs{
    $pMap
    
    List<String> paramList = [];
    param.forEach((eachKey, eachValue) {
      if(eachValue != null) {
        paramList.add('\$eachKey=\$eachValue');
      }
    });
    String paramStr = paramList.join('&');
    return "yyy://page/$urlKey?\$paramStr";
    }
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
    String value = "";
    _allImport.forEach((element) {
      value += element;
    });
    var importString = value;
    return 'import "package:flutter/material.dart";\n' +
        'import "package:yyy_route_annotation/yyy_route_annotation.dart";\n'+
        importString +
        "\n" +
        "Map<String, WidgetBuilder> routes(){\n"+
        "routeMapping.addAll({$_allBody});\n"+
        "return routeMapping.map((key, value) => MapEntry(key, value.widgetBuilder));"
            "}\n\n"+
        "class RoutMapping{$_allInterface}"
    ;
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
