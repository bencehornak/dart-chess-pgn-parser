import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:test/test.dart';

import 'test_data.dart' as test_data;

void main() {
  final game = test_data.buildChessHalfMoveTree();
  final expectedLinearChessMoveSequences = LinearMoveSequenceTree(
    LinearMoveSequenceTreeNode.rootNodeWithLateParentInit(
      sequence: [],
      children: [
        // 1. d4
        LinearMoveSequenceTreeNode.withLateParentInit(
          sequence: [
            LinearChessMoveSequenceItem(node: game.rootNode.children[0]),
          ],
          children: [],
        ),
        // 1. e4
        LinearMoveSequenceTreeNode.withLateParentInit(
          sequence: [
            LinearChessMoveSequenceItem(node: game.rootNode.children[1]),
          ],
          children: [
            // 1... e5 2. Nc3 Nf6
            LinearMoveSequenceTreeNode.withLateParentInit(
              sequence: [
                LinearChessMoveSequenceItem(
                    node: game.rootNode.children[1].children[0]),
                LinearChessMoveSequenceItem(
                    node: game.rootNode.children[1].children[0].children[0]),
                LinearChessMoveSequenceItem(
                    node: game.rootNode.children[1].children[0].children[0]
                        .children[0]),
              ],
              children: [],
            ),
            // 1... e6
            LinearMoveSequenceTreeNode.withLateParentInit(
              sequence: [
                LinearChessMoveSequenceItem(
                    node: game.rootNode.children[1].children[1]),
              ],
              children: [],
            ),
          ],
        ),
      ],
    ),
  )..fixParentsRecursively();
  test('fromGame()', () {
    final sequences = LinearMoveSequenceTree.fromGame(game);

    expect(
      sequences,
      expectedLinearChessMoveSequences,
    );
  });
  test('toString()', () {
    expect(expectedLinearChessMoveSequences.toString(), '''
LinearMoveSequenceTree(
  1. d4
  1. e4
    1... e5 2. Nc3 Nf6
    1... e6
)''');
  });
}
