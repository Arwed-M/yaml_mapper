List<dynamic> parseList(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  final String indention = indentMarker * (indentLevel + 1);
  List<dynamic> list = [];

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().isEmpty) continue;
    if (i < lines.length - 1 && lines[i + 1].startsWith(indention)) {
      // TODO
      // implement same logic as in parse Map
    } else {
      list.add(replaceQuotation(lines[i].trim().replaceFirst('- ', '')));
    }
  }
  return list;
}

/// Replaces quotation marks at the beginning/end of value
dynamic replaceQuotation(String text) {
  for (var mark in ['"', "'"]) {
    if (text.indexOf(mark) == 0) text = text.replaceFirst(mark, '');
    if (text.endsWith(mark)) {
      text = text.substring(0, text.length - 1);
    }
  }
  return text;
}

/// Returns the [String] used for indentation in [List<String> lines].
String determineWhitespace(List<String> lines) {
  for (var line in lines) {
    String? match = RegExp(r'^\s+').stringMatch(line);
    if (match != null) {
      return match;
    }
  }
  return '  ';
}
