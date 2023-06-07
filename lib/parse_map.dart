/// Parses a YAML Map from the [List<String> lines] of a file.
Map<String, dynamic> parseMap(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  Map<String, dynamic> map = {};

  for (int i = 0; i < lines.length; i++) {
    String whitespace = indentMarker * (indentLevel + 1);
    final String line = lines[i].trim();

    List<String> lineSplit = line.split(':');
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

      // get YAML List or recursion
      map[key] = _isList(lines[i + 1])
          ? _createList(lines.sublist(mapStartIndex, mapEndIndex))
          : parseMap(lines.sublist(mapStartIndex, mapEndIndex), indentMarker,
              indentLevel: indentLevel + 1);
      i += (mapEndIndex - mapStartIndex);
    }
    // no further indentation
    else if (line.isNotEmpty) {
      map[key] = _replaceQuotation(
          line.replaceFirst('${lineSplit.first}:', '').trim());
    }
  }

  return map;
}

bool _isList(String line) => (line.trim().substring(0, 2) == '- ' &&
    (!line.contains(': ') || _escapedColon(line)));

/// check wether an occuring colon is inside quotations
bool _escapedColon(String line) =>
    RegExp(r"""[^('|")].*:""").firstMatch(line)?.start != null;

List<dynamic> _createList(List<String> lines) {
  return lines
      .map((line) => _replaceQuotation(line.trim().replaceFirst('- ', '')))
      .toList();
}

/// Replaces quotation marks at the beginning/end of value
dynamic _replaceQuotation(String text) {
  // handle empty String
  if (text == '""' || text == "''") {
    return '';
  } else if (text.isEmpty) {
    return null;
  }

  ['"', "'"].map((mark) {
    if (text.indexOf(mark) == 0) text = text.replaceFirst(mark, '');
    if (text.lastIndexOf(mark) == text.length - 1) {
      text = text.substring(0, text.length - 1);
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
dynamic getPathValue(List<String> keyPath, Map<String, dynamic> map) {
  dynamic getToNextLvl(String level, Map<String, dynamic> map) => map[level];

  Map<String, dynamic> tempLvlMap = map;
  dynamic value = '';

  for (var level in keyPath) {
    dynamic tmp = getToNextLvl(level, tempLvlMap);
    if (level != keyPath.last) {
      tempLvlMap = tmp;
    } else {
      value = tmp;
    }
  }

  return value;
}
