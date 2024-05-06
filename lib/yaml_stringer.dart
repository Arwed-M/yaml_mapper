/// creates YAML syntax
class YamlStringer {
  static String indent(int i) => '  ' * i;

  static String strKey(String key, String val, int i) =>
      '${indent(i) + key}: "${val.trim()}"\n';

  static String numKey(String key, num val, int i) =>
      '${indent(i) + key}: $val\n';

  static String nullKey(String key, int i) => '${indent(i) + key}: null\n';

  static String map(String key, String val, int i) =>
      '${indent(i)}$key: \n$val\n';

  static String list(String key, List<dynamic> list, int i) {
    String str = '${indent(i) + key}:\n';
    for (String line in list) {
      str += '${indent(i + 1)}- "$line"\n';
    }
    return str;
  }

  static String empty(String key, int i) => '${indent(i) + key}: \n';
}
