import 'package:yaml_mapper/yaml_stringer.dart';
import 'node_type.dart';

/// adds a dynamic value to [YamlMap] with the depth definded by [KeyPath]
YamlMap addValToMap(YamlMap map, List<String> keyPath, dynamic value) =>
    YamlMap.from({
      ...map,
      keyPath.first: keyPath.length == 1
          ? value
          : addValToMap(map[keyPath.removeAt(0)] ?? {}, keyPath, value)
    });

/// Converts a [Map<String, dynamic>] to the YAML syntax
String toYaml(YamlMap map, {int indentation = 0}) {
  String lines = '';

  for (var key in map.keys) {
    if (map[key] is Map) {
      lines += YamlStringer.map(
          key, toYaml(map[key], indentation: indentation + 1), indentation);
    } else if (map[key] is List) {
      lines += YamlStringer.list(key, map[key], indentation);
    } else if (map[key] is String) {
      lines += YamlStringer.keyVal(key, map[key], indentation);
    } else {
      lines += YamlStringer.empty(key, indentation);
    }
  }

  return lines;
}
