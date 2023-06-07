import 'package:yaml_mapper/yaml_mapper.dart';

/// Removes a key from a map with the depth definded by [List<String> keyPath]
/// and cleans up afterwards
void removeFromMap(Map<String, dynamic> map, List<String> keyPath) {
  _deleteKey(map, [...keyPath]);
  _removeEmptyness(map, keyPath.sublist(0, keyPath.length - 1));
}

void _deleteKey(Map<String, dynamic> map, List<String> keyPath) {
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
  } else {
    _deleteKey(map[keyPath.removeAt(0)], keyPath);
  }
}

/// Removes empty keys which might remain after removal of single keys
void _removeEmptyness(Map<String, dynamic> map, List<String> keyPath) {
  for (int i = keyPath.length; i > 0; i--) {
    List<String> path = keyPath.sublist(0, i);
    if (getPathValue(path, map).isEmpty) _deleteKey(map, path);
  }
}
