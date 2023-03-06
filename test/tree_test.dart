import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:test/test.dart';

void main() {
  GameWithVariations game = _buildGame();
  group('traverse()', () {
    test('traverse() lastMove argument is correct', () {
      // This object is only used to accessed the move_to_san method (which should be static IMO)
      final chess = Chess();

      List<String> actualPath = [];
      game.traverse(
          (Chess board, AnnotatedMove lastMove, List<AnnotatedMove> nextMoves) {
        actualPath.add(chess.move_to_san(lastMove));
      });
      List<String> expectedDfsPath = ['d4', 'e4', 'e5', 'Nc3', 'Nf6', 'e6'];
      expect(actualPath, expectedDfsPath);
    });
    test('traverse() nextMoves argument is correct', () {
      // This object is only used to accessed the move_to_san method (which should be static IMO)
      final chess = Chess();

      List<List<String>> actualPath = [];
      game.traverse(
          (Chess board, AnnotatedMove lastMove, List<AnnotatedMove> nextMoves) {
        actualPath
            .add(nextMoves.map((move) => chess.move_to_san(move)).toList());
      });
      List<List<String>> expectedDfsPath = [
        [], // d4
        ['e5', 'e6'], // e4
        ['Nc3'], // e5
        ['Nf6'], // Nc3
        [], // Nf6
        [], // e6
      ];
      expect(actualPath, expectedDfsPath);
    });
    test('traverse() board argument is correct', () {
      List<String> actualPath = [];
      game.traverse(
          (Chess board, AnnotatedMove lastMove, List<AnnotatedMove> nextMoves) {
        actualPath.add(board.ascii);
      });
      List<String> expectedDfsPath = [
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  n  r |\n'
            ' 7 | p  p  p  p  p  p  p  p |\n'
            ' 6 | .  .  .  .  .  .  .  . |\n'
            ' 5 | .  .  .  .  .  .  .  . |\n'
            ' 4 | .  .  .  P  .  .  .  . |\n'
            ' 3 | .  .  .  .  .  .  .  . |\n'
            ' 2 | P  P  P  .  P  P  P  P |\n'
            ' 1 | R  N  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  n  r |\n'
            ' 7 | p  p  p  p  p  p  p  p |\n'
            ' 6 | .  .  .  .  .  .  .  . |\n'
            ' 5 | .  .  .  .  .  .  .  . |\n'
            ' 4 | .  .  .  .  P  .  .  . |\n'
            ' 3 | .  .  .  .  .  .  .  . |\n'
            ' 2 | P  P  P  P  .  P  P  P |\n'
            ' 1 | R  N  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  n  r |\n'
            ' 7 | p  p  p  p  .  p  p  p |\n'
            ' 6 | .  .  .  .  .  .  .  . |\n'
            ' 5 | .  .  .  .  p  .  .  . |\n'
            ' 4 | .  .  .  .  P  .  .  . |\n'
            ' 3 | .  .  .  .  .  .  .  . |\n'
            ' 2 | P  P  P  P  .  P  P  P |\n'
            ' 1 | R  N  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  n  r |\n'
            ' 7 | p  p  p  p  .  p  p  p |\n'
            ' 6 | .  .  .  .  .  .  .  . |\n'
            ' 5 | .  .  .  .  p  .  .  . |\n'
            ' 4 | .  .  .  .  P  .  .  . |\n'
            ' 3 | .  .  N  .  .  .  .  . |\n'
            ' 2 | P  P  P  P  .  P  P  P |\n'
            ' 1 | R  .  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  .  r |\n'
            ' 7 | p  p  p  p  .  p  p  p |\n'
            ' 6 | .  .  .  .  .  n  .  . |\n'
            ' 5 | .  .  .  .  p  .  .  . |\n'
            ' 4 | .  .  .  .  P  .  .  . |\n'
            ' 3 | .  .  N  .  .  .  .  . |\n'
            ' 2 | P  P  P  P  .  P  P  P |\n'
            ' 1 | R  .  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
        '   +------------------------+\n'
            ' 8 | r  n  b  q  k  b  n  r |\n'
            ' 7 | p  p  p  p  .  p  p  p |\n'
            ' 6 | .  .  .  .  p  .  .  . |\n'
            ' 5 | .  .  .  .  .  .  .  . |\n'
            ' 4 | .  .  .  .  P  .  .  . |\n'
            ' 3 | .  .  .  .  .  .  .  . |\n'
            ' 2 | P  P  P  P  .  P  P  P |\n'
            ' 1 | R  N  B  Q  K  B  N  R |\n'
            '   +------------------------+\n'
            '     a  b  c  d  e  f  g  h\n',
      ];
      expect(actualPath, expectedDfsPath);
    });
  });
}

GameWithVariations _buildGame() {
  return GameWithVariations(
      // Depth: 1st half move
      [
        // d4
        GameNode(
            AnnotatedMove(Color.WHITE, Chess.SQUARES['d2'], Chess.SQUARES['d4'],
                0, PieceType.PAWN, null, null, 'd4'),
            []),
        // e4
        GameNode(
            AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'], Chess.SQUARES['e4'],
                0, PieceType.PAWN, null, null, 'e4'),
            // Depth: 2nd half move
            [
              // e5
              GameNode(
                  AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
                      Chess.SQUARES['e5'], 0, PieceType.PAWN, null, null, 'e5'),
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
                  AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
                      Chess.SQUARES['e6'], 0, PieceType.PAWN, null, null, 'e6'),
                  [])
            ])
      ]);
}
