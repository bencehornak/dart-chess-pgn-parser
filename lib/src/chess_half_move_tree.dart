import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:chess_pgn_parser/src/tree_iterator.dart';

import 'annotated_move.dart';

class ChessHalfMoveTree extends Tree<ChessHalfMoveTreeNode> {
  ChessHalfMoveTree(super.rootNode);

  /// Traverse the tree in DFS order.
  void traverse(
      void Function(Chess board, ChessHalfMoveTreeNode node) callback) {
    final iterator = ChessHalfMoveDepthFirstSearchTreeIterator(this);
    while (iterator.moveNext()) {
      final element = iterator.current;
      callback(element.board, element.node);
    }
  }

  @override
  String toString() {
    String formatMove(AnnotatedMove move) {
      final commentText = move.comment == null ? '' : ' {${move.comment}}';
      return '${'  ' * (move.totalHalfMoveNumber - 1)}${move.toHumanReadable()}$commentText';
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

class ChessHalfMoveDepthFirstSearchTreeIterator
    extends DepthFirstSearchTreeIterator<ChessHalfMoveTree,
        ChessHalfMoveTreeNode, ChessHalfMoveTreeIteratorElement> {
  final _board = Chess();

  ChessHalfMoveDepthFirstSearchTreeIterator(super.tree);

  @override
  ChessHalfMoveTreeIteratorElement transformNode(ChessHalfMoveTreeNode node) =>
      ChessHalfMoveTreeIteratorElement(node: node, board: _board);

  @override
  void onStepIn(ChessHalfMoveTreeNode node) {
    _board.move(node.move);
  }

  @override
  void onStepOut() {
    _board.undo_move();
  }

  @override
  void onTraversalFinished() {
    assert(_board.move_number == 1,
        'We should arrive back to the start after performing the DFS');
  }
}

class ChessHalfMoveTreeIteratorElement {
  final ChessHalfMoveTreeNode node;
  final Chess board;

  const ChessHalfMoveTreeIteratorElement(
      {required this.node, required this.board});
}
