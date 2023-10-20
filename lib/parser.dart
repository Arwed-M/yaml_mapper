import 'extentions.dart';
import 'node_type.dart';

/// Parses a [YamlMap] from the [lines] of a file.
/// [indentMarker] specifies the used [String] for indentation
YamlMap parseMap(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  YamlMap map = {};

  for (int i = 0; i < lines.length; i++) {
    final String indention = indentMarker * (indentLevel + 1);
    final String line = lines[i].trim();

    List<String> lineSplit = line.split(':');
    String key = lineSplit.first.trim();

    if (line.isEmpty) continue;

    // if next line is indented compared to current line
    if (i < lines.length - 1 && lines[i + 1].startsWith(indention)) {
      i = _parseSublevel(
          map, key, lines, i, indention, indentMarker, indentLevel);
    }

    // no further indentation
    else {
      final String value = line.replaceFirst('$key: ', '').trim();
      map[key] = value.isNull ? null : _replaceQuotation(value);
    }
  }

  return map;
}

List<dynamic> parseList(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  final String indention = indentMarker * (indentLevel + 1);
  List<dynamic> list = [];

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().isEmpty) continue;
    if (i < lines.length - 1 && lines[i + 1].startsWith(indention)) {
      final String key =
          lines[i].split(':').first.trim().replaceFirst('- ', '');
      YamlMap map = {};
      i = _parseSublevel(
          map, key, lines, i, indention, indentMarker, indentLevel);
      list.add(map);
    } else {
      list.add(_replaceQuotation(lines[i].trim().replaceFirst('- ', '')));
    }
  }
  return list;
}

int _parseSublevel(YamlMap map, String key, List<String> lines, int i,
    String indention, String indentMarker, int indentLevel) {
  // define start and end of key:value block
  final int start = i + 1;
  int end = start + 1;

  // count until indentLevel decreases
  while (end < lines.length &&
      (lines[end].startsWith(indention) || lines[end].trim().isEmpty)) {
    end++;
  }

  // get YAML List or recursion
  map[key] = lines[i + 1].isYamlList
      ? parseList(lines.sublist(start, end), indentMarker,
          indentLevel: indentLevel + 1)
      : parseMap(lines.sublist(start, end), indentMarker,
          indentLevel: indentLevel + 1);
  return i + (end - start);
}

/// Replaces quotation marks at the beginning/end of value
dynamic _replaceQuotation(String text) {
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
