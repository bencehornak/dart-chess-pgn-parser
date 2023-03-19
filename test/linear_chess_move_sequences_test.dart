import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:test/test.dart';

import 'test_data.dart' as test_data;

void main() {
  final game = test_data.buildChessHalfMoveTree();
  final expectedLinearChessMoveSequences = LinearChessMoveSequences(
    [
      // 1. d4
      LinearChessMoveSequence(
        depth: 0,
        sequence: [
          LinearChessMoveSequenceItem(node: game.rootNode.children[0]),
        ],
      ),
      // 1. e4
      LinearChessMoveSequence(
        depth: 0,
        sequence: [
          LinearChessMoveSequenceItem(node: game.rootNode.children[1]),
        ],
      ),
      // 1... e5 2. Nc3 Nf6
      LinearChessMoveSequence(
        depth: 1,
        sequence: [
          LinearChessMoveSequenceItem(
              node: game.rootNode.children[1].children[0]),
          LinearChessMoveSequenceItem(
              node: game.rootNode.children[1].children[0].children[0]),
          LinearChessMoveSequenceItem(
              node: game
                  .rootNode.children[1].children[0].children[0].children[0]),
        ],
      ),
      // 1... e6
      LinearChessMoveSequence(
        depth: 1,
        sequence: [
          LinearChessMoveSequenceItem(
              node: game.rootNode.children[1].children[1]),
        ],
      ),
    ],
  );
  test('fromGame()', () {
    final sequences = LinearChessMoveSequences.fromGame(game);

    expect(
      sequences,
      expectedLinearChessMoveSequences,
    );
  });
  test('toString()', () {
    expect(
        expectedLinearChessMoveSequences.toString(),
        'LinearChessMoveSequences(\n'
        '  sequences: [\n'
        '    LinearChessMoveSequence(depth: 0, sequence: 1. d4),\n'
        '    LinearChessMoveSequence(depth: 0, sequence: 1. e4),\n'
        '    LinearChessMoveSequence(depth: 1, sequence: 1... e5 2. Nc3 Nf6),\n'
        '    LinearChessMoveSequence(depth: 1, sequence: 1... e6)\n'
        '  ]\n'
        ')');
  });
}
