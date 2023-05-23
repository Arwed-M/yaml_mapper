/// Returns the [String] used for indentation in [List<String> lines].
String _determineWhitespace(List<String> lines) {
  for (var line in lines) {
    String? match = RegExp(r'^\s+').stringMatch(line);
    if (match != null) {
      return match;
    }
  }
  return '  ';
}

/// Parses a YAML Map from the [List<String> lines] of a file.
Map<String, dynamic> parseMap(List<String> lines, {int indentLevel = 0}) {
  final String usedWhitespace = _determineWhitespace(lines);
  Map<String, dynamic> map = {};

  for (int i = 0; i < lines.length; i++) {
    String whitespace = usedWhitespace * (indentLevel + 1);
    List<String> lineSplit = lines[i].split(':');
    String key = lineSplit.first.trim();

    // if next line is indented compared to current line
    if (i < lines.length - 1 && lines[i + 1].indexOf(whitespace) == 0) {
      final int mapStartIndex = i + 1;
      int mapEndIndex = mapStartIndex + 1;

      while (mapEndIndex < lines.length &&
          (lines[mapEndIndex].indexOf(whitespace) == 0 ||
              lines[mapEndIndex].trim().isEmpty)) {
        mapEndIndex++;
      }

      map[key] = parseMap(lines.sublist(mapStartIndex, mapEndIndex),
          indentLevel: indentLevel + 1);
      i += (mapEndIndex - mapStartIndex);
    }
    // no further indentation
    else if (lines[i].trim().isNotEmpty) {
      map[key] = lines[i]
          .replaceFirst('${lineSplit.first}:', '')
          .replaceAll('"', '')
          .trim();
    }
  }

  return map;
}
