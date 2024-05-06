import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml_mapper/types.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

void main() {
  final List<String> lines = File('test/basic_map.yaml').readAsLinesSync();

  test('Parsing test', () {
    final yaml = parseMap(lines, determineWhitespace(lines));

    expect(yaml['firstMap']['entry1'], 'this is an entry');
    expect(yaml['superNestedMap']['entry1']['vogelNest'], 'juhu');
    expect(yaml['superNestedMap']['entry2'], 'This is a String');
    expect(yaml['superNestedMap']['entry3'], 'This is also a String');
    expect(yaml['superNestedMap']['entry4']['evenMoreNested'],
        'hmm very nested indeed');
    expect(yaml['superNestedMap']['entry5'], [
      'I am a: list entry',
      'hey, this is also a l:st',
      'Am I a List ": entry"',
      {
        'nestedList': ['hey I am nested inside a List', 'me too']
      }
    ]);
  });

  test('Adding and removal test', () {
    YamlMap map = {
      'entry1': {
        'nested1': 'val1',
      },
      'entry2': 'val'
    };

    map = addValToMap(map, ['entry1', 'nested2'], {'nested': 'test'});
    map = addValToMap(map, ['entry1', 'nested3'], 3);
    map = addValToMap(map, ['entry3', 'nested'], 42);

    removeFromMap(map, ['entry1', 'nested1'], cleanup: true);
    removeFromMap(map, ['entry1', 'nested2', 'nested'], cleanup: true);
    removeFromMap(map, ['entry1', 'nested3'], cleanup: true);
    removeFromMap(map, ['entry3', 'nested']);
    expect(map, {'entry2': 'val', 'entry3': {}});
  });

  test('toYaml conversion test', () {
    YamlMap map = {
      'e1': 'haha',
      'e2': {'e21': 'v21', 'e22': 'v22'},
      'e3': 'hallo'
    };

    String expectedRes = """
e1: "haha"
e2: 
  e21: "v21"
  e22: "v22"

e3: "hallo"
""";
    expect(toYaml(map), expectedRes);
  });
}
