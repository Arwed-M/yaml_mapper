import 'node_type.dart';

/// Removes a key from a map with the depth definded by [KeyPath]
/// and cleans up afterwards
void removeFromMap(YamlMap map, KeyPath keyPath) {
  _deleteKey(map, [...keyPath]);
  _removeEmptyness(map, keyPath.sublist(0, keyPath.length - 1));
}

void _deleteKey(YamlMap map, KeyPath keyPath) {
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

/// Returns the [String] from a [KeyPath]
dynamic getPathValue(KeyPath keyPath, YamlMap map) {
  YamlMap tempLvlMap = map;
  dynamic value = '';

  for (var level in keyPath) {
    dynamic tmp = tempLvlMap[level];
    if (level != keyPath.last) {
      tempLvlMap = tmp;
    } else {
      value = tmp;
    }
  }

  return value;
}

/// Removes empty keys which might remain after removal of single keys
void _removeEmptyness(YamlMap map, KeyPath keyPath) {
  for (int i = keyPath.length; i > 0; i--) {
    KeyPath path = keyPath.sublist(0, i);
    if (getPathValue(path, map).isEmpty) _deleteKey(map, path);
  }
}
