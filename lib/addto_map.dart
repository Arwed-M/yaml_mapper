import 'package:yaml_mapper/yaml_stringer.dart';
import 'node_type.dart';

/// adds a dynamic value to [YamlMap] with the depth definded by [KeyPath]
YamlMap addValToMap(YamlMap map, List<String> keyPath, dynamic value) =>
    // uwu
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
    switch (NodeType.fromObj(map[key])) {
      case NodeType.string:
        lines += YamlStringer.keyVal(key, map[key], indentation);
        break;
      case NodeType.map:
        lines += YamlStringer.map(
            key, toYaml(map[key], indentation: indentation + 1), indentation);
        break;
      case NodeType.empty:
        lines += YamlStringer.empty(key, indentation);
        break;
      default:
    }
  }

  return lines;
}
