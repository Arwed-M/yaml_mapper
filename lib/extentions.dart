extension StringYamlUtils on String {
  bool get isYamlList =>
      (trim().substring(0, 2) == '- ' && (!contains(': ') || _hasEscapedColon));

  /// check wether an occuring colon is inside quotations
  bool get _hasEscapedColon =>
      RegExp(r"""[^('|")].*:""").firstMatch(this)?.start != null;

  bool get isNull => isEmpty;

  /// Replaces quotation marks at the beginning/end of value
  String get replaceQuotation {
    String str = this;
    for (var mark in ['"', "'"]) {
      if (str.startsWith(mark)) str = str.replaceFirst(mark, '');
      if (str.endsWith(mark)) str = str.substring(0, str.length - 1);
    }
    return str;
  }
}

extension MapUtils on Map<String, dynamic> {
  Map<String, dynamic> flattenMap() {
    Map<String, dynamic> result = {};

    void flatten(String prefix, Map<String, dynamic> innerMap) {
      innerMap.forEach((key, value) {
        String newKey = prefix.isEmpty ? key : '$prefix.$key';
        if (value is Map) {
          flatten(newKey, value as Map<String, dynamic>);
        } else {
          result[newKey] = value;
        }
      });
    }

    flatten('', this);
    return result;
  }
}
