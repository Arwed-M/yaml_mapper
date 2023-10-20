typedef YamlMap = Map<String, dynamic>;
typedef KeyPath = List<String>;

enum NodeType {
  string,
  map,
  empty;

  static NodeType? fromObj(Object? obj) =>
      fromString(obj.runtimeType.toString());

  static NodeType? fromString(String str) =>
      NodeType.values.firstWhere((e) => e.match == str);

  String get match {
    switch (this) {
      case NodeType.string:
        return "String";
      case NodeType.map:
        return "_Map<String, dynamic>";
      case NodeType.empty:
        return "Null";
    }
  }
}
