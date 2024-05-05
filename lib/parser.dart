import 'extentions.dart';
import 'node_type.dart';

/// Parses a [YamlMap] from the [lines] of a file.
/// [indentMarker] specifies the used [String] for indentation
YamlMap parseMap(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  final String nextIndent = indentMarker * (indentLevel + 1);
  YamlMap map = {};

  for (int i = 0; i < lines.length; i++) {
    final String line = lines[i].trim();
    final String key = line.split(':').first.trim();

    if (line.isEmpty) continue;

    // if next line is indented compared to current line
    if (i < lines.length - 1 && lines[i + 1].startsWith(nextIndent)) {
      // parse the indented value, returns the ending line index
      i = _parseIndentation(
          map, key, lines, i, nextIndent, indentMarker, indentLevel);
    }

    // no further indentation
    else {
      final String value = line.replaceFirst('$key:', '').trim();
      map[key] = value.isEmpty ? null : value.replaceQuotation;
    }
  }

  return map;
}

/// Parses a Yaml-List to a [List<dynamic>]
List<dynamic> parseList(List<String> lines, String indentMarker,
    {int indentLevel = 0}) {
  final String nextIndent = indentMarker * (indentLevel + 1);
  List<dynamic> list = [];

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().isEmpty) continue;
    if (i < lines.length - 1 && lines[i + 1].startsWith(nextIndent)) {
      final String key =
          lines[i].split(':').first.trim().replaceFirst('- ', '');
      YamlMap map = {};
      i = _parseIndentation(
          map, key, lines, i, nextIndent, indentMarker, indentLevel);
      list.add(map);
    } else {
      list.add(lines[i].trim().replaceFirst('- ', '').replaceQuotation);
    }
  }
  return list;
}

/// Parses through an indentation (recursive) and returns the ending line index
int _parseIndentation(YamlMap map, String key, List<String> lines, int i,
    String indentation, String indentMarker, int indentLevel) {
  // define start and end of key:value block
  final int start = i + 1;
  int end = start + 1;

  // count until indentLevel decreases
  while (end < lines.length &&
      (lines[end].startsWith(indentation) || lines[end].trim().isEmpty)) {
    end++;
  }

  // get Yaml List or recursion
  map[key] = lines[i + 1].isYamlList
      ? parseList(lines.sublist(start, end), indentMarker,
          indentLevel: indentLevel + 1)
      : parseMap(lines.sublist(start, end), indentMarker,
          indentLevel: indentLevel + 1);
  return i + (end - start);
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
