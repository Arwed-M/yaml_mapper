import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaml_mapper/yaml_mapper.dart';

void main() {
  final List<String> lines = File('test/basic_map.yaml').readAsLinesSync();
  final yaml = parseMap(lines, '  ');

  test('Parsing test', () {
    expect(yaml['firstMap']['entry1'], 'this is an entry');
    expect(yaml['superNestedMap']['entry1']['vogelNest'], 'juhu');
    expect(yaml['superNestedMap']['entry2'], 'This is a String');
    expect(yaml['superNestedMap']['entry3'], 'This is also a String');
    expect(yaml['superNestedMap']['entry4']['evenMoreNested'],
        'hmm very nested indeed');
    expect(yaml['superNestedMap']['entry5'], [
      'I am a: list entry',
      'hey, this is also a l:st',
      'Am I a List ": entry"'
    ]);
  });

  test('Removal test', () {
    Map<String, dynamic> map = {
      'entry1': {
        'nested1': 'val1',
        'nested2': {'nested': 'test'}
      },
      'entry2': 'val'
    };

    removeFromMap(map, ['entry1', 'nested1']);
    removeFromMap(map, ['entry1', 'nested2', 'nested']);
    expect(map, {'entry2': 'val'});
  });
}
