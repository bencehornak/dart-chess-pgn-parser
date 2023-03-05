import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:test/test.dart';

void main() {
  group('Game tree tests', () {
    GameWithVariations? game;
    setUp(() {
      game = GameWithVariations(
          // Depth: 1st half move
          [
            // d4
            GameNode(
                AnnotatedMove(Color.WHITE, Chess.SQUARES['d2'],
                    Chess.SQUARES['d4'], 0, PieceType.PAWN, null, null),
                []),
            // e4
            GameNode(
                AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'],
                    Chess.SQUARES['e4'], 0, PieceType.PAWN, null, null),
                // Depth: 2nd half move
                [
                  // e5
                  GameNode(
                      AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
                          Chess.SQUARES['e5'], 0, PieceType.PAWN, null, null),
                      []),
                  // e6
                  GameNode(
                      AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
                          Chess.SQUARES['e6'], 0, PieceType.PAWN, null, null),
                      [])
                ])
          ]);
    });
    test('traverse() lastMove argument is correct', () {
      // This object is only used to accessed the move_to_san method (which should be static IMO)
      final chess = Chess();

      List<String> actualPath = [];
      game!.traverse(
          (Chess board, AnnotatedMove lastMove, List<AnnotatedMove> nextMoves) {
        actualPath.add(chess.move_to_san(lastMove));
      });
      List<String> expectedDfsPath = [
        'd4',
        'e4',
        'e5',
        'e6',
      ];
      expect(actualPath, expectedDfsPath);
    });
    test('traverse() nextMoves argument is correct', () {
      // This object is only used to accessed the move_to_san method (which should be static IMO)
      final chess = Chess();

      List<List<String>> actualPath = [];
      game!.traverse(
          (Chess board, AnnotatedMove lastMove, List<AnnotatedMove> nextMoves) {
        actualPath
            .add(nextMoves.map((move) => chess.move_to_san(move)).toList());
      });
      List<List<String>> expectedDfsPath = [
        [], // d4
        ['e5', 'e6'], // e4
        [], // e5
        [], // e6
      ];
      expect(actualPath, expectedDfsPath);
    });
  });
}
