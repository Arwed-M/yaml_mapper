/// Parses a YAML Map from the [List<String> lines] of a file.
Map<String, dynamic> parseMap(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  Map<String, dynamic> map = {};

  for (int i = 0; i < lines.length; i++) {
    String whitespace = indentMarker * (indentLevel + 1);
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

      map[key] = parseMap(
          lines.sublist(mapStartIndex, mapEndIndex), indentMarker,
          indentLevel: indentLevel + 1);
      i += (mapEndIndex - mapStartIndex);
    }
    // no further indentation
    else if (lines[i].trim().isNotEmpty) {
      map[key] = _replaceQuotation(lineSplit[1].trim());
    }
  }

  return map;
}

String _replaceQuotation(String text) {
  ['"', "'"].map((mark) {
    if (text.indexOf(mark) == 0) text = text.replaceFirst(mark, '');
    if (text.lastIndexOf(mark) == text.length - 1) {
      text = text.replaceRange(text.length - 1, text.length, '');
    }
  }).toList();
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

/// Returns the [String value] from a [List<String> keyPath]
String getPathValue(List<String> keyPath, Map<String, dynamic> map) {
  dynamic getToNextLvl(String level, Map<String, dynamic> map) => map[level];

  Map<String, dynamic> tempLvlMap = map;
  String text = '';

  for (var level in keyPath) {
    dynamic tmp = getToNextLvl(level, tempLvlMap);
    if (level != keyPath.last) {
      tempLvlMap = tmp;
    } else {
      text = tmp;
    }
  }

  return text;
}
