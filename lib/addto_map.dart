import 'dart:io';

/// adds a [dynamic value] to [Map<String, dynamic> yaml] with the depth definded
/// by [List<String> keyPath]
Map<String, dynamic> addPathToMap(
        Map<String, dynamic> map, List<String> keyPath, dynamic value) =>
    keyPath.length == 1
        ? Map<String, dynamic>.from({...map, keyPath.first: value})
        : Map<String, dynamic>.from({
            ...map,
            keyPath.first:
                addPathToMap(map[keyPath.removeAt(0)] ?? {}, keyPath, value)
          });

/// Save the [Map<String, dynamic>] to a YAML file
void writeYAML(Map<String, dynamic> yaml, String asset) =>
    File(asset).writeAsStringSync(_createYAMLLines(yaml));

/// Format a line according to YAML syntax
String _createYAMLLines(Map<String, dynamic> map, {int indentation = 0}) {
  String lines = '';

  map.keys.map((key) {
    switch (map[key].runtimeType.toString()) {
      case 'String':
        lines += '${'  ' * indentation + key}: "${map[key].trim()}"\n';
        break;
      case '_Map<String, dynamic>':
        lines +=
            '${'  ' * indentation}$key: \n${_createYAMLLines(map[key], indentation: indentation + 1)}\n';
        break;
      default:
    }
  }).toList();

  return lines;
}
