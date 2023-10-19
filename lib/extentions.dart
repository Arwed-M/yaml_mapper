extension StringYamlUtils on String {
  bool get isYamlList =>
      (trim().substring(0, 2) == '- ' && (!contains(': ') || _hasEscapedColon));

  /// check wether an occuring colon is inside quotations
  bool get _hasEscapedColon =>
      RegExp(r"""[^('|")].*:""").firstMatch(this)?.start != null;

  bool get isNull => isEmpty;
}
