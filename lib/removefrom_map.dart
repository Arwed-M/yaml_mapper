import 'package:yaml_mapper/yaml_mapper.dart';

/// Removes a key from a map with the depth definded by [List<String> keyPath]
void removeFromMap(Map<String, dynamic> map, List<String> keyPath) {
  // not valid
  if (keyPath.isEmpty) return;

  // toplevel key
  if (keyPath.length == 1) {
    map.remove(keyPath.last);
    return;
  }

  // nested keys
  if (keyPath.length == 2) {
    map[keyPath[keyPath.length - 2]].remove(keyPath.last);
    _removeEmptyness(map, keyPath.sublist(0, keyPath.length - 1));
  } else {
    removeFromMap(map[keyPath.removeAt(0)], keyPath);
  }
}

/// Removes empty keys which might remain after removal of single keys
void _removeEmptyness(Map<String, dynamic> map, List<String> keyPath) {
  for (int i = keyPath.length - 1; i >= 0; i--) {
    List<String> path = keyPath.sublist(0, i + 1);
    if (getPathValue(path, map).isEmpty) removeFromMap(map, path);
  }
}
