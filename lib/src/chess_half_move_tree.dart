import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:logging/logging.dart';

import 'annotated_move.dart';

final _logger = Logger('ChessHalfMoveTree');

class ChessHalfMoveTree extends Tree<ChessHalfMoveTreeNode> {
  ChessHalfMoveTree(super.rootNode);

  /// Traverse the tree in DFS order.
  void traverse(
      void Function(Chess board, ChessHalfMoveTreeNode node) callback) {
    _logger.fine('Starting traverse()');

    final board = Chess();

    // A stack data structure used by the DFS algorithm.
    //
    // It contains:
    //   1. ChessHalfMoveTreeNode objects, whose meaning is to step one level
    //      deeper in the tree in the corresponding direction
    //   2. nulls, which encode to step one level back in the tree
    //
    // The last element of the stack will be the next one being visited, that's
    // why elements are added in reverse order.
    List<ChessHalfMoveTreeNode?> stack = [];
    void addToStack(List<ChessHalfMoveTreeNode> children) {
      final addToStack = children
          .expand((e) => [
                e, // step deeper
                null, // step back
              ])
          .toList()
          .reversed;
      _logger.finest('Adding to stack: $addToStack');
      stack.addAll(addToStack);
    }

    addToStack([rootNode]);
    while (stack.isNotEmpty) {
      ChessHalfMoveTreeNode? node = stack.removeLast();
      _logger.finest('Popping ${node?.move}');
      if (node == null) {
        board.undo_move();
      } else {
        board.move(node.move);
        callback(board, node);
        addToStack(node.children);
      }
      _logger.finest('Move number: ${board.move_number}');
    }

    assert(board.move_number == 1,
        'We should arrive back to the start after performing the DFS');
    _logger.fine('Leaving traverse()');
  }

  @override
  String toString() {
    String formatMove(AnnotatedMove move) {
      return '${'  ' * (move.totalHalfMoveNumber - 1)}${move.toHumanReadable()}';
    }

    final buffer = StringBuffer();
    buffer.write('ChessHalfMoveTree(\n');
    traverse((board, node) {
      if (node.rootNode) return;

      buffer.write('  ${formatMove(node.move!)}\n');
    });
    buffer.write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ChessHalfMoveTree) return false;
    return toString() == (other).toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class ChessHalfMoveTreeNode extends TreeNode<ChessHalfMoveTreeNode> {
  /// The corresponding [AnnotatedMove].
  ///
  /// Initialized for all [ChessHalfMoveTreeNode], except for the root node (see
  /// [rootNode]).
  final AnnotatedMove? move;

  /// Variation depth.
  ///
  /// {@template variation_depth}
  /// The value 0 represents the main-line, 1 means a side-line, 2 means a
  /// side-line of a side-line and so on.
  /// {@endtemplate}
  final int variationDepth;

  bool get rootNode => parent == null;

  /// {@macro tree_node_root_node_with_late_children_init}
  ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit()
      : move = null,
        variationDepth = 0,
        super.rootNodeWithLateChildrenInit();

  /// {@macro tree_node_with_late_children_init}
  ChessHalfMoveTreeNode.withLateChildrenInit(
      {required AnnotatedMove move,
      required ChessHalfMoveTreeNode parent,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        super.withLateChildrenInit(parent: parent);

  /// {@macro tree_node_root_node_with_late_parent_init}
  ChessHalfMoveTreeNode.rootNodeWithLateParentInit(
      {required List<ChessHalfMoveTreeNode> children})
      : move = null,
        variationDepth = 0,
        super.rootNodeWithLateParentInit(children: children);

  /// {@macro tree_node_with_late_parent_init}
  ChessHalfMoveTreeNode.withLateParentInit(
      {required AnnotatedMove move,
      required List<ChessHalfMoveTreeNode> children,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        super.withLateParentInit(children: children);

  @override
  String toString() => 'ChessHalfMoveTreeNode(move: ${move?.san})';
}
