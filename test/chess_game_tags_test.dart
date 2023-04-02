import 'package:chess_pgn_parser/src/chess_game_tags.dart';
import 'package:test/test.dart';
import 'test_data.dart' as test_data;

void main() {
  group('Correct input', () {
    final tags = test_data.buildChessGameTags();

    test('event', () {
      expect(tags.event, 'Test');
    });
    test('site', () {
      expect(tags.site, 'Test Site');
    });
    test('date', () {
      expect(tags.date, DateTime(2023, 03, 06));
    });
    test('round', () {
      expect(tags.round, '23');
    });
    test('white', () {
      expect(tags.white, ['Bence Hornák', 'His friends']);
    });
    test('black', () {
      expect(tags.black, ['Bence Hornák']);
    });
    test('result', () {
      expect(tags.result, '*');
    });
  });
  group('Empty values', () {
    ['-', '?'].forEach((emptyString) {
      test('\'$emptyString\' is treated as empty', () {
        final tags = test_data.buildChessGameTags(overrides: {
          'Round': [emptyString]
        });
        expect(tags.round, isNull);
      });
    });
  });
  group('Missing required tags', () {
    [
      'Event',
      'Site',
      'Date',
      'Round',
      'White',
      'Black',
      'Result',
    ].forEach((missingTag) {
      test('Missing tag $missingTag', () {
        expect(() => test_data.buildChessGameTags(removeTags: [missingTag]),
            throwsA(isA<ChessGameTagsParsingException>()));
      });
    });
  });
}
