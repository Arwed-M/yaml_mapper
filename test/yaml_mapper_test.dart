import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:yaml_mapper/yaml_mapper.dart';

void main() {
  test('Test a simple map', () {
    final List<String> lines = File('test/basic_map.yaml').readAsLinesSync();
    final yaml = parseMap(lines, '  ');

    expect(yaml['firstMap']['entry1'], 'this is an entry');
    expect(yaml['superNestedMap']['entry1']['vogelNest'], 'juhu');
    expect(yaml['superNestedMap']['entry2'], 'This is a String');
    expect(yaml['superNestedMap']['entry3'], 'This is also a String');
    expect(yaml['superNestedMap']['entry4']['evenMoreNested'],
        'hmm yery nested indeed');
  });
}
