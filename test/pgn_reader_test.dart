import 'dart:async';
import 'dart:io';

import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  final String expectedGameTree = '''
[GameWithVariations(
  1. d4
  1. e4
    1... e5
      2. Nc3
        2... Nf6
    1... e6
)]''';

  StreamSubscription<LogRecord>? loggerSubscription;

  setUpAll(() {
    Logger.root.level = Level.ALL;
    loggerSubscription = Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  });
  tearDownAll(() {
    Logger.root.level = Level.INFO; // restore default
    loggerSubscription!.cancel();
  });

  group('simple', () {
    test('fromString().parse() returns the tree', () async {
      String input = await File('test/resources/pgn/simple.pgn').readAsString();
      final reader = PgnReader.fromString(input);

      final tree = reader.parse();

      expect(tree.toString(), expectedGameTree);
    });
  });
  group('advanced', () {
    test('fromString().parse() returns the tree', () async {
      String input =
          await File('test/resources/pgn/advanced.pgn').readAsString();
      final reader = PgnReader.fromString(input);

      expect(() => reader.parse(), returnsNormally);
    });
  });
  group('invalid input', () {
    test('fromString().parse() throws PgnReaderException', () async {
      String input =
          await File('test/resources/pgn/invalid.pgn').readAsString();
      final reader = PgnReader.fromString(input);

      expect(
          () => reader.parse(),
          throwsA(isA<PgnReaderException>()
              .having((error) => error.ctx.start, 'ctx.start', 1)
              .having((error) => error.ctx.stop, 'ctx.stop', 1)));
    });
  });
}
