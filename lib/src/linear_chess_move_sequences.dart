import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';

final _listEquals = const ListEquality().equals;

/// It breaks down a [ChessHalfMoveTree] to consecutive linear chunks.
///
/// ## Example
/// Let's say that we have a [ChessHalfMoveTree] tree represented by the
/// following tree:
///
/// ```
/// <root>
/// ├─ 1. d4
/// └─ 1. e4
///     ├─ 1... e5
///     │   └─ 2. Nc3
///     │       └─ 2... Nf6
///     └─ 1... e6
/// ```
///
/// The structure of the output [LinearChessMoveSequences] will look like this:
/// ```
/// LinearChessMoveSequences(
///   sequences: [
///     LinearChessMoveSequence(depth: 0, sequence: 1. d4),
///     LinearChessMoveSequence(depth: 0, sequence: 1. e4),
///     LinearChessMoveSequence(depth: 1, sequence: 1... e5 2. Nc3 Nf6),
///     LinearChessMoveSequence(depth: 1, sequence: 1... e6)
///   ]
/// )
/// ```
class LinearChessMoveSequences {
  final List<LinearChessMoveSequence> sequences;

  @visibleForTesting
  LinearChessMoveSequences(this.sequences);

  factory LinearChessMoveSequences.fromGame(ChessHalfMoveTree game,
      {bool captureBoards = false}) {
    final List<LinearChessMoveSequence> linearChessMoveSequencesOut = [];
    final List<LinearChessMoveSequence> linearChessMoveSequencesStack = [];

    game.traverse((board, node) {
      if (node.rootNode) return; // Root node has no visualization

      // Start a new sequence, if this is the first traversed node, or if the
      // node's parent has multiple children.
      if (linearChessMoveSequencesStack.isEmpty ||
          node.parent!.children.length > 1) {
        while (linearChessMoveSequencesStack.isNotEmpty &&
            linearChessMoveSequencesStack
                    .last.sequence.first.node.move!.totalHalfMoveNumber >=
                node.move!.totalHalfMoveNumber) {
          linearChessMoveSequencesStack.removeLast();
        }

        var newSequence = LinearChessMoveSequence._(
            depth: linearChessMoveSequencesStack.length);
        linearChessMoveSequencesOut.add(newSequence);
        linearChessMoveSequencesStack.add(newSequence);
      }
      final boardCopy = captureBoards ? board.copy() : null;
      linearChessMoveSequencesStack.last._addSequenceItem(
          LinearChessMoveSequenceItem(node: node, board: boardCopy));
    });
    return LinearChessMoveSequences(linearChessMoveSequencesOut);
  }

  @override
  String toString() => 'LinearChessMoveSequences(\n'
      '  sequences: [\n'
      '    ${sequences.join(',\n    ')}\n'
      '  ]\n'
      ')';

  @override
  bool operator ==(Object other) =>
      other is LinearChessMoveSequences &&
      _listEquals(sequences, other.sequences);

  @override
  int get hashCode => sequences.hashCode;
}

/// A linear consecutive chunk of chess moves.
///
/// Both ends of the sequence are either
/// 1. decision points in the tree (nodes, which have multiple children),
/// 2. the root node (not including the root node itself)
/// 3. or the end of the variation
class LinearChessMoveSequence {
  final int depth;
  final List<LinearChessMoveSequenceItem> sequence;

  @visibleForTesting
  LinearChessMoveSequence({required this.depth, required this.sequence});
  LinearChessMoveSequence._({required this.depth}) : sequence = [];

  void _addSequenceItem(LinearChessMoveSequenceItem item) {
    sequence.add(item);
  }

  @override
  String toString() {
    final sequenceString = sequence.isEmpty
        ? 'empty'
        : sequence
            .asMap()
            .entries
            .map((mapEntry) => mapEntry.value.node.move!.toHumanReadable(
                showBlackMoveNumberIndicator: mapEntry.key == 0))
            .join(' ');
    return 'LinearChessMoveSequence(depth: $depth, sequence: $sequenceString)';
  }

  @override
  bool operator ==(Object other) =>
      other is LinearChessMoveSequence &&
      depth == other.depth &&
      _listEquals(sequence, other.sequence);

  @override
  int get hashCode => depth ^ sequence.hashCode;
}

class LinearChessMoveSequenceItem {
  final ChessHalfMoveTreeNode node;
  final Chess? board;

  @visibleForTesting
  LinearChessMoveSequenceItem({
    required this.node,
    this.board,
  });

  @override
  bool operator ==(Object other) =>
      other is LinearChessMoveSequenceItem
      // If the nodes are identical, the board should also be.
      &&
      identical(node, other.node);

  @override
  int get hashCode => node.hashCode;
}
