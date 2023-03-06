import 'dart:async';
import 'dart:io';

import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

void main() {
  final expectedGameTree = [
    GameWithVariations(
        // Depth: 1st half move
        [
          // d4
          GameNode(
              AnnotatedMove(Color.WHITE, Chess.SQUARES['d2'],
                  Chess.SQUARES['d4'], 0, PieceType.PAWN, null, null, 'd4'),
              []),
          // e4
          GameNode(
              AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'],
                  Chess.SQUARES['e4'], 0, PieceType.PAWN, null, null, 'e4'),
              // Depth: 2nd half move
              [
                // e5
                GameNode(
                    AnnotatedMove(
                        Color.BLACK,
                        Chess.SQUARES['e7'],
                        Chess.SQUARES['e5'],
                        0,
                        PieceType.PAWN,
                        null,
                        null,
                        'e5'),
                    [
                      // Nc3
                      GameNode(
                          AnnotatedMove(
                              Color.WHITE,
                              Chess.SQUARES['b1'],
                              Chess.SQUARES['c3'],
                              0,
                              PieceType.KNIGHT,
                              null,
                              null,
                              'Nc3'),
                          [
                            // Nf6
                            GameNode(
                                AnnotatedMove(
                                    Color.BLACK,
                                    Chess.SQUARES['g8'],
                                    Chess.SQUARES['f6'],
                                    0,
                                    PieceType.KNIGHT,
                                    null,
                                    null,
                                    'Nf6'),
                                []),
                          ]),
                    ]),
                // e6
                GameNode(
                    AnnotatedMove(
                        Color.BLACK,
                        Chess.SQUARES['e7'],
                        Chess.SQUARES['e6'],
                        0,
                        PieceType.PAWN,
                        null,
                        null,
                        'e6'),
                    [])
              ])
        ])
  ];

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

      expect(tree, expectedGameTree);
    });
  });
}
