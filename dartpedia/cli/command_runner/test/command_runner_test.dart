import 'package:command_runner/command_runner.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final commandRunner = CommandRunner('test', 'A test command runner.');

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      expect(commandRunner.executableName, equals('test'));
    });
  });
}
