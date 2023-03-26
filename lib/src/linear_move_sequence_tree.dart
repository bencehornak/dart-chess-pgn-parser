import 'package:meta/meta.dart';
import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';

import 'tree_iterator.dart';

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
///     │       └─ 2... Nc6
///     └─ 1... e6
/// ```
///
/// The structure of the output [LinearMoveSequenceTree] will look like this
/// (each line corresponds to a [LinearMoveSequenceTreeNode], the moves in one
/// line are the elements of the [LinearMoveSequenceTreeNode.sequence] list):
/// ```
/// LinearMoveSequenceTree(
///   1. d4
///   1. e4
///     1... e5 2. Nc3
///       2... Nf6
///       2... Nc6
///     1... e6
/// )
/// ```
class LinearMoveSequenceTree extends Tree<LinearMoveSequenceTreeNode> {
  @visibleForTesting
  LinearMoveSequenceTree(super.rootNode);

  factory LinearMoveSequenceTree.fromGame(ChessHalfMoveTree game,
      {bool captureBoards = false}) {
    final List<LinearMoveSequenceTreeNode> linearChessMoveSequencesStack = [];

    final rootNode = LinearMoveSequenceTreeNode.rootNodeWithLateChildrenInit();
    linearChessMoveSequencesStack.add(rootNode);

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

        final parent = linearChessMoveSequencesStack.last;
        final newSequence =
            LinearMoveSequenceTreeNode.withLateChildrenInit(parent: parent);
        parent.children.add(newSequence);
        linearChessMoveSequencesStack.add(newSequence);
      }
      final boardCopy = captureBoards ? board.copy() : null;
      linearChessMoveSequencesStack.last._addSequenceItem(
          LinearChessMoveSequenceItem(node: node, board: boardCopy));
    });
    return LinearMoveSequenceTree(rootNode);
  }

  /// Traverse the tree in DFS order.
  void traverse(void Function(LinearMoveSequenceTreeNode node) callback) {
    final iterator = SimpleDepthFirstSearchTreeIterator<LinearMoveSequenceTree,
        LinearMoveSequenceTreeNode>(this);
    while (iterator.moveNext()) {
      final element = iterator.current;
      callback(element);
    }
  }

  @override
  String toString() {
    final out = StringBuffer();
    out.write('LinearMoveSequenceTree(\n');

    traverse((linearChessMoveSequence) {
      if (linearChessMoveSequence.rootNode) return;
      out.write('  ' * linearChessMoveSequence.depth);

      linearChessMoveSequence.sequence.asMap().forEach((index, sequenceItem) {
        bool firstOneInSequence = index == 0;

        if (!firstOneInSequence) out.write(' ');

        out.write(sequenceItem.node.move!
            .toHumanReadable(showBlackMoveNumberIndicator: firstOneInSequence));
      });
      out.write('\n');
    });

    out.write(')');

    return out.toString();
  }
}

/// A linear consecutive chunk of chess moves.
///
/// Both ends of the sequence are either
/// 1. decision points in the tree (nodes, which have multiple children),
/// 2. the root node (not including the root node itself)
/// 3. or the end of the variation
class LinearMoveSequenceTreeNode extends TreeNode<LinearMoveSequenceTreeNode> {
  final List<LinearChessMoveSequenceItem> sequence;

  /// {@macro tree_node_root_node_with_late_children_init}
  LinearMoveSequenceTreeNode.rootNodeWithLateChildrenInit()
      : sequence = [],
        super.rootNodeWithLateChildrenInit();

  /// {@macro tree_node_with_late_children_init}
  LinearMoveSequenceTreeNode.withLateChildrenInit(
      {required LinearMoveSequenceTreeNode parent})
      : sequence = [],
        super.withLateChildrenInit(parent: parent);

  /// {@macro tree_node_root_node_with_late_parent_init}
  LinearMoveSequenceTreeNode.rootNodeWithLateParentInit({
    required this.sequence,
    required List<LinearMoveSequenceTreeNode> children,
  }) : super.rootNodeWithLateParentInit(children: children);

  /// {@macro tree_node_with_late_parent_init}
  LinearMoveSequenceTreeNode.withLateParentInit(
      {required this.sequence,
      required List<LinearMoveSequenceTreeNode> children})
      : super.withLateParentInit(children: children);

  void _addSequenceItem(LinearChessMoveSequenceItem item) {
    sequence.add(item);
  }
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