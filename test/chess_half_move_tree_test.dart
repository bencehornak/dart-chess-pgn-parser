import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:test/test.dart';

import 'test_data.dart' as test_data;

void main() {
  ChessHalfMoveTree game = test_data.buildChessHalfMoveTree();

  group('depth', () {
    test('depth == move.move_count', () {
      game.traverse((board, node) {
        if (node.rootNode) return;
        expect(
            node.depth,
            inInclusiveRange(
                2 * node.move!.moveNumber - 1, 2 * node.move!.moveNumber));
      });
    });
  });

  group('traverse()', () {
    test('traverse() lastMove argument is correct', () {
      List<String?> actualPath = [];
      game.traverse((Chess board, ChessHalfMoveTreeNode node) {
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
      game.traverse((Chess board, ChessHalfMoveTreeNode node) {
        actualPath.add(node.children.map((child) => child.move?.san).toList());
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
      game.traverse((Chess board, ChessHalfMoveTreeNode node) {
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
ChessHalfMoveTree(
  tags:
    Event: Test
    Site: Test Site
    Date: 2023.03.06
    Round: 23
    White: Bence Hornák:His friends
    Black: Bence Hornák
    Result: *
  moves:
    1. d4
    1. e4
      1... e5 2. Nc3 Nf6
      1... e6
)''');
  });

  group('operator==()', () {
    test('true', () {
      expect(game, test_data.buildChessHalfMoveTree());
    });

    test('false', () {
      expect(
          game,
          isNot(ChessHalfMoveTree(
              tags: test_data.buildChessGameTags(),
              rootNode: ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit())));
    });
  });

  group('hashCode', () {
    test('equals', () {
      expect(game.hashCode, test_data.buildChessHalfMoveTree().hashCode);
    });

    test('does not equal', () {
      expect(
          game.hashCode,
          isNot(ChessHalfMoveTree(
                  tags: test_data.buildChessGameTags(),
                  rootNode:
                      ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit())
              .hashCode));
    });
  });
}
