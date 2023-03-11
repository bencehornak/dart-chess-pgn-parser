import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:test/test.dart';

void main() {
  GameWithVariations game = _buildGame();

  group('AnnotatedMove', () {
    final firstWhiteMove = AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'],
        Chess.SQUARES['e4'], 0, PieceType.PAWN, null, null, 1, 'e4');
    final firstBlackMove = AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
        Chess.SQUARES['e5'], 0, PieceType.PAWN, null, null, 1, 'e5');
    group('totalHalfMoveNumber', () {
      test('First white move', () {
        expect(firstWhiteMove.totalHalfMoveNumber, 1);
      });
      test('First black move', () {
        expect(firstBlackMove.totalHalfMoveNumber, 2);
      });
    });
    group('toHumanReadable', () {
      test('White', () {
        expect(firstWhiteMove.toHumanReadable(), '1. e4');
      });
      test('Black (showBlackMoveNumberIndicator: true)', () {
        expect(
            firstBlackMove.toHumanReadable(showBlackMoveNumberIndicator: true),
            '1... e5');
      });
      test('Black (showBlackMoveNumberIndicator: false)', () {
        expect(
            firstBlackMove.toHumanReadable(showBlackMoveNumberIndicator: false),
            'e5');
      });
    });
  });
  group('GameWithVariations', () {
    group('traverse()', () {
      test('traverse() lastMove argument is correct', () {
        List<String?> actualPath = [];
        game.traverse((Chess board, GameNode node) {
          actualPath.add(node.move?.san);
        });
        List<String?> expectedDfsPath = [
          null, // rootNode
          'd4',
          'e4',
          'e5',
          'Nc3',
          'Nf6',
          'e6'
        ];
        expect(actualPath, expectedDfsPath);
      });
      test('traverse() nextMoves argument is correct', () {
        List<List<String?>> actualPath = [];
        game.traverse((Chess board, GameNode node) {
          actualPath
              .add(node.children.map((child) => child.move?.san).toList());
        });
        List<List<String>?> expectedDfsPath = [
          ['d4', 'e4'], // rootNode
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
        game.traverse((Chess board, GameNode node) {
          actualPath.add(board.ascii);
        });
        List<String?> expectedDfsPath = [
          '   +------------------------+\n'
              ' 8 | r  n  b  q  k  b  n  r |\n'
              ' 7 | p  p  p  p  p  p  p  p |\n'
              ' 6 | .  .  .  .  .  .  .  . |\n'
              ' 5 | .  .  .  .  .  .  .  . |\n'
              ' 4 | .  .  .  .  .  .  .  . |\n'
              ' 3 | .  .  .  .  .  .  .  . |\n'
              ' 2 | P  P  P  P  P  P  P  P |\n'
              ' 1 | R  N  B  Q  K  B  N  R |\n'
              '   +------------------------+\n'
              '     a  b  c  d  e  f  g  h\n',
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

    test('toString()', () {
      expect(game.toString(), '''
GameWithVariations(
  1. d4
  1. e4
    1... e5
      2. Nc3
        2... Nf6
    1... e6
)''');
    });

    group('operator==()', () {
      test('true', () {
        expect(game, _buildGame());
      });

      test('false', () {
        expect(game,
            isNot(GameWithVariations(GameNode.rootNodeWithLateChildrenInit())));
      });
    });

    group('hashCode', () {
      test('equals', () {
        expect(game.hashCode, _buildGame().hashCode);
      });

      test('does not equal', () {
        expect(
            game.hashCode,
            isNot(GameWithVariations(GameNode.rootNodeWithLateChildrenInit())
                .hashCode));
      });
    });
  });
}

GameWithVariations _buildGame() {
  return GameWithVariations(GameNode.rootNodeWithLateParentInit(
      // Depth: 1st half move
      [
        // d4
        GameNode.withLateParentInit(
            AnnotatedMove(Color.WHITE, Chess.SQUARES['d2'], Chess.SQUARES['d4'],
                0, PieceType.PAWN, null, null, 1, 'd4'),
            []),
        // e4
        GameNode.withLateParentInit(
            AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'], Chess.SQUARES['e4'],
                0, PieceType.PAWN, null, null, 1, 'e4'),
            // Depth: 2nd half move
            [
              // e5
              GameNode.withLateParentInit(
                  AnnotatedMove(
                      Color.BLACK,
                      Chess.SQUARES['e7'],
                      Chess.SQUARES['e5'],
                      0,
                      PieceType.PAWN,
                      null,
                      null,
                      1,
                      'e5'),
                  [
                    // Nc3
                    GameNode.withLateParentInit(
                        AnnotatedMove(
                            Color.WHITE,
                            Chess.SQUARES['b1'],
                            Chess.SQUARES['c3'],
                            0,
                            PieceType.KNIGHT,
                            null,
                            null,
                            2,
                            'Nc3'),
                        [
                          // Nf6
                          GameNode.withLateParentInit(
                              AnnotatedMove(
                                  Color.BLACK,
                                  Chess.SQUARES['g8'],
                                  Chess.SQUARES['f6'],
                                  0,
                                  PieceType.KNIGHT,
                                  null,
                                  null,
                                  2,
                                  'Nf6'),
                              []),
                        ]),
                  ]),
              // e6
              GameNode.withLateParentInit(
                  AnnotatedMove(
                      Color.BLACK,
                      Chess.SQUARES['e7'],
                      Chess.SQUARES['e6'],
                      0,
                      PieceType.PAWN,
                      null,
                      null,
                      1,
                      'e6'),
                  [])
            ])
      ]))
    ..fixParentsRecursively();
}
