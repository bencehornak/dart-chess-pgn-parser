import 'dart:async';
import 'dart:io';

import 'package:antlr4/antlr4.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  final String expectedGameTree = '''
[ChessHalfMoveTree(
  1. e4
    1... e5
      2. Nc3
        2... Nf6
    1... e6
  1. d4
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

  group('simple.pgn', () {
    late List<ChessHalfMoveTree> tree;

    setUpAll(() async {
      String input = await File('test/resources/pgn/simple.pgn').readAsString();
      final reader = PgnReader.fromString(input);

      tree = reader.parse();
    });

    test('fromString().parse() returns the tree', () async {
      expect(tree.toString(), expectedGameTree);
    });
    test('variationDepth of root is 0', () {
      expect(tree[0].rootNode.variationDepth, 0);
    });
    test('variationDepth of e4 is 0', () {
      expect(
          tree[0]
              .rootNode
              .children
              .firstWhere((element) => element.move!.san == 'e4')
              .variationDepth,
          0);
    });
    test('variationDepth of d4 is 1', () {
      expect(
          tree[0]
              .rootNode
              .children
              .firstWhere((element) => element.move!.san == 'd4')
              .variationDepth,
          1);
    });
  });
  test('advanced.pgn - fromString().parse() returns the tree', () async {
    String input = await File('test/resources/pgn/advanced.pgn').readAsString();
    final reader = PgnReader.fromString(input);

    List<ChessHalfMoveTree>? database;
    expect(() => database = reader.parse(), returnsNormally);
    expect(() => database!.toString(), returnsNormally);
  });
  test('invalid.pgn fromString().parse() throws PgnReaderException', () async {
    String input = await File('test/resources/pgn/invalid.pgn').readAsString();
    final reader = PgnReader.fromString(input);

    expect(
        () => reader.parse(),
        throwsA(isA<PgnReaderException>()
            .having(
                (error) => error.ctx.start,
                'ctx.start',
                isA<Token>()
                    // start Token
                    .having((token) => token.line, 'line', 1)
                    .having((token) => token.charPositionInLine,
                        'charPositionInLine', 0))
            .having(
                (error) => error.ctx.stop,
                'ctx.stop',
                isA<Token>()
                    // stop Token
                    .having((token) => token.line, "line", 1)
                    .having((token) => token.charPositionInLine,
                        "charPositionInLine", 0))));
  });
  test('invalid-move-number.pgn fromString().parse() throws PgnReaderException',
      () async {
    String input =
        await File('test/resources/pgn/invalid-move-number.pgn').readAsString();
    final reader = PgnReader.fromString(input);

    expect(
        () => reader.parse(),
        throwsA(isA<PgnReaderException>()
            .having(
                (error) => error.ctx.start,
                'ctx.start',
                isA<Token>()
                    // start Token
                    .having((token) => token.line, 'line', 9)
                    .having((token) => token.charPositionInLine,
                        'charPositionInLine', 9))
            .having(
                (error) => error.ctx.stop,
                'ctx.stop',
                isA<Token>()
                    // stop Token
                    .having((token) => token.line, "line", 9)
                    .having((token) => token.charPositionInLine,
                        "charPositionInLine", 10))));
  });
}
