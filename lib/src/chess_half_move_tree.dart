import 'package:chess/chess.dart';
import 'package:logging/logging.dart';

import 'annotated_move.dart';

final _logger = Logger('ChessHalfMoveTree');

class ChessHalfMoveTree {
  final ChessHalfMoveTreeNode rootNode;

  ChessHalfMoveTree(this.rootNode);

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

  /// Fixes the [ChessHalfMoveTreeNode] objects, which were constructed with
  /// [ChessHalfMoveTreeNode.rootNodeWithLateParentInit] or
  /// [ChessHalfMoveTreeNode.withLateParentInit]
  void fixParentsRecursively() {
    final List<ChessHalfMoveTreeNode> stack = [];
    stack.addAll([rootNode]);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      node.children.forEach((child) {
        child._parent = node;
        stack.add(child);
      });
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! ChessHalfMoveTree) return false;
    return toString() == (other).toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class ChessHalfMoveTreeNode {
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
  final List<ChessHalfMoveTreeNode> children;
  ChessHalfMoveTreeNode? get parent => _parent;
  ChessHalfMoveTreeNode? _parent;

  bool get rootNode => _parent == null;

  /// Constructor for the root node, which delays the initialization of
  /// [children].
  ///
  /// {@template game_node_late_children_init}
  /// To handle the circular dependency between parents and their children, add
  /// the children later to the [children] list.
  /// {@endtemplate}
  ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit()
      : _parent = null,
        children = [],
        move = null,
        variationDepth = 0;

  /// Constructor, which sets [parent] right away, but delays the initialization
  /// of [children].
  ///
  /// {@macro game_node_late_children_init}
  ChessHalfMoveTreeNode.withLateChildrenInit(
      {required AnnotatedMove move,
      required ChessHalfMoveTreeNode parent,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        _parent = parent,
        children = [];

  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent].
  ///
  /// {@template game_node_late_parent_init}
  /// You can set [parent] later by calling
  /// [ChessHalfMoveTree.fixParentsRecursively] on the corresponding
  /// [ChessHalfMoveTree] object.
  /// {@endtemplate}
  ChessHalfMoveTreeNode.rootNodeWithLateParentInit({required this.children})
      : move = null,
        _parent = null,
        variationDepth = 0;

  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent].
  ///
  /// {@macro game_node_late_parent_init}
  ChessHalfMoveTreeNode.withLateParentInit(
      {required AnnotatedMove move,
      required this.children,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        _parent = null;

  @override
  String toString() => 'ChessHalfMoveTreeNode(move: ${move?.san})';
}
