import 'dart:async';
import 'dart:io';

import 'package:antlr4/antlr4.dart';
import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:chess_pgn_parser/src/evaluation.dart';
import 'package:chess_pgn_parser/src/shape.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
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
    final String expectedGameTree = '''
[ChessHalfMoveTree(
  tags:
    Event: Test
    Site: Test Site
    Date: 2023.03.06
    Round: -
    White: Bence Hornák:His friends
    Black: Bence Hornák
    Result: *
  moves:
    1. e4
      1... e5 2. Nc3 {but the Vienna-opening is great too} Nf6
      1... e6
    1. d4 {d4 openings are great}
)]''';

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

  group('Non-standard comment annotations', () {
    late ChessHalfMoveTree tree;

    AnnotatedMove getMove(String san) => tree.rootNode.children
        .firstWhere((node) => node.move!.san == san)
        .move!;

    setUpAll(() async {
      String input =
          await File('test/resources/pgn/nonstandard-annotations.pgn')
              .readAsString();
      final reader = PgnReader.fromString(input);

      tree = reader.parse()[0];
    });

    test('%clk is parsed', () {
      final move = getMove('a3');
      expect(move.clock, 1 * 3600 + 55 * 60 + 21);
    });
    test('%emt is parsed', () {
      final move = getMove('b3');
      expect(move.elapsedMoveTime, 5 * 60 + 42);
    });
    test('%eval is parsed (PawnEvaluation)', () {
      final move = getMove('c3');
      expect(move.evaluation,
          PawnEvaluation(difference: -6.05, analysisDepth: null));
    });
    test('%eval is parsed (MateInNEvaluation)', () {
      final move = getMove('d3');
      expect(move.evaluation, MateInNEvaluation(n: 3, analysisDepth: null));
    });
    test('%cal is parsed', () {
      final move = getMove('e3');
      expect(move.visualAnnotations, [
        Arrow(
            color: VisualAnnotationColor.green,
            from: Chess.SQUARES['c7'],
            to: Chess.SQUARES['f4']),
        Arrow(
            color: VisualAnnotationColor.yellow,
            from: Chess.SQUARES['e4'],
            to: Chess.SQUARES['b7']),
        Arrow(
            color: VisualAnnotationColor.red,
            from: Chess.SQUARES['c4'],
            to: Chess.SQUARES['c5']),
        Arrow(
            color: VisualAnnotationColor.blue,
            from: Chess.SQUARES['a2'],
            to: Chess.SQUARES['a4']),
      ]);
    });
    test('%csl is parsed', () {
      final move = getMove('f3');
      expect(move.visualAnnotations, [
        HighlightedSquare(
            color: VisualAnnotationColor.green, square: Chess.SQUARES['c7']),
        HighlightedSquare(
            color: VisualAnnotationColor.green, square: Chess.SQUARES['d5']),
        HighlightedSquare(
            color: VisualAnnotationColor.red, square: Chess.SQUARES['d6']),
      ]);
    });
    test('Multiple annotations are parsed', () {
      final move = getMove('g3');
      expect(move.clock, isNotNull);
      expect(move.visualAnnotations, isNotEmpty);
    });
    test('empty comment next to non-standard annotation', () {
      final move = getMove('a3');
      expect(move.comment, isNull);
    });
    test('comment parsed before non-standard annotation', () {
      final move = getMove('c3');
      expect(move.comment, 'test');
    });
    test('comment parsed after non-standard annotation', () {
      final move = getMove('e3');
      expect(move.comment, 'test');
    });
  });
}
