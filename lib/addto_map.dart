import 'package:yaml_mapper/types.dart';
import 'package:yaml_mapper/yaml_stringer.dart';

/// Adds a dynamic value to [YamlMap] with the depth definded by [KeyPath]
/// and returns the new [YamlMap]
YamlMap addValToMap(YamlMap map, List<String> keyPath, dynamic value) {
  var keyPathCpy = KeyPath.from(keyPath);
  return YamlMap.from({
    ...map,
    keyPathCpy.first: keyPathCpy.length == 1
        ? value
        : addValToMap(map[keyPathCpy.removeAt(0)] ?? {}, keyPathCpy, value)
  });
}

/// Converts a [Map<String, dynamic>] to the YAML syntax
String toYaml(YamlMap map, {int indentation = 0}) {
  String lines = '';

  for (var key in map.keys) {
    if (map[key] is Map && map[key].isNotEmpty) {
      lines += YamlStringer.map(
          key, toYaml(map[key], indentation: indentation + 1), indentation);
    } else if (map[key] is List) {
      lines += YamlStringer.list(key, map[key], indentation);
    } else if (map[key] is String) {
      lines += YamlStringer.strKey(key, map[key], indentation);
    } else if (map[key] is num) {
      lines += YamlStringer.numKey(key, map[key], indentation);
    } else if (map[key] == null || map[key].isEmpty) {
      lines += YamlStringer.nullKey(key, indentation);
    } else {
      lines += YamlStringer.empty(key, indentation);
    }
  }

  return lines;
}
