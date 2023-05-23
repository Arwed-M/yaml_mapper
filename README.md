<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

YAML Mapper is a simple YAML Map parser, which creates a `Map<String, dynamic>` from a `List<String>` in dart.

## Usage

```dart
final List<String> lines = File('myFile.yaml').readAsLinesSync();
final Map<String, dynamic> yaml = parseMap(lines);

print(yaml['entry']);
```