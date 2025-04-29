import 'package:yaml_mapper/types.dart';

/// Removes a key from a map with the depth definded by [KeyPath]
/// and returns the removed value
dynamic removeFromMap(YamlMap map, KeyPath keyPath, {bool cleanup = false}) {
  KeyPath pathCpy = KeyPath.from(keyPath);
  final val = _deleteKey(map, keyPath);
  _cleanUp(map, pathCpy.sublist(0, pathCpy.length - 1), cleanup);
  return val;
}

dynamic _deleteKey(YamlMap map, KeyPath keyPath) {
  // not valid
  if (keyPath.isEmpty) return null;

  // toplevel key
  if (keyPath.length == 1) {
    return map.remove(keyPath.last);
  }

  Object val = map[keyPath.removeAt(0)];
  if (val is YamlMap) {
    return _deleteKey(val, keyPath);
  } else if (val is List) {
    return val.remove(keyPath.last);
  }
}

/// Returns the value from a [KeyPath]
dynamic getPathValue(KeyPath keyPath, YamlMap map) {
  YamlMap? tempLvlMap = map;
  dynamic value = tempLvlMap;

  for (var level in keyPath) {
    dynamic tmp = tempLvlMap?[level];
    if (level != keyPath.last) {
      tempLvlMap = tmp;
    } else {
      value = tmp;
    }
  }

  return value;
}

/// Removes empty keys which might remain after removal of single keys
void _cleanUp(YamlMap map, KeyPath keyPath, bool removeEmptyVals) {
  for (int i = keyPath.length; i > 0; i--) {
    KeyPath path = keyPath.sublist(0, i);
    if (removeEmptyVals && getPathValue(path, map).isEmpty) {
      _deleteKey(map, path);
    }
  }
}
