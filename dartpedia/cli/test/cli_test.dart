import 'package:cli/cli.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  group('GetArticleCommand', () {
    final logger = Logger('test');
    final command = GetArticleCommand(logger: logger);

    test('name is correct', () {
      expect(command.name, equals('article'));
    });

    test('description is correct', () {
      expect(command.description, equals('Read an article from Wikipedia'));
    });
  });

  group('SearchCommand', () {
    final logger = Logger('test');
    final command = SearchCommand(logger: logger);

    test('name is correct', () {
      expect(command.name, equals('search'));
    });

    test('description is correct', () {
      expect(command.description, equals('Search for Wikipedia articles.'));
    });
  });
}
