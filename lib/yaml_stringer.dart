/// creates YAML syntax
class YamlStringer {
  static String indent(int i) => '  ' * i;

  static String keyVal(String key, String val, int i) =>
      '${indent(i) + key}: "${val.trim()}"\n';

  static String map(String key, String val, int i) =>
      '${indent(i)}$key: \n$val\n';

  static String empty(String key, int i) => '${indent(i) + key}: \n';
}
