import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../chess_pgn_parser.dart';

/// Abstract base class for tree iterators.
///
/// The algorithm of choice for the iteration is up to its implementors. [T] is
/// the [Tree] type, [N] is the corresponding node type. [E] is the element type
/// of the [Iterator] (the node can be transformed to a different data type).
abstract class TreeIterator<T extends Tree<N>, N extends TreeNode<N>, E>
    extends Iterator<E> {
  final T tree;

  TreeIterator(this.tree);
}

/// A Depth First Search [TreeIterator] implementation.
abstract class DepthFirstSearchTreeIterator<T extends Tree<N>,
    N extends TreeNode<N>, E> extends TreeIterator<T, N, E> {
  static final _logger = Logger('DepthFirstSearchTreeIterator');

  /// A stack data structure used by the DFS algorithm.
  ///
  /// It contains:
  ///   1. ChessHalfMoveTreeNode objects, whose meaning is to step one level
  ///      deeper in the tree in the corresponding direction
  ///   2. nulls, which encode to step one level back in the tree
  ///
  /// The last element of the stack will be the next one being visited, that's
  /// why elements are added in reverse order.
  final List<N?> _stack = [];
  E? _currentElement;

  DepthFirstSearchTreeIterator(super.tree) {
    _addToStack([tree.rootNode]);
  }

  @override
  bool moveNext() {
    while (_stack.isNotEmpty) {
      N? node = _stack.removeLast();
      _logger.finest('Popping $node');
      if (node == null) {
        onStepOut();
      } else {
        onStepIn(node);
        _addToStack(node.children);
        final currentNode = node;
        _currentElement = transformNode(currentNode);

        return true;
      }
    }

    _logger.fine('Traversal finished');
    onTraversalFinished();
    return false;
  }

  @override
  E get current => _currentElement!;

  /// Transforms a node (of type [N]) to an [Iterator] element (of type [E]).
  E transformNode(N node);

  /// Called when the DFS algorithm steps into a node of a deeper level.
  @protected
  void onStepIn(N node);

  /// Called when the DFS algorithm steps out of a node.
  @protected
  void onStepOut();

  /// Called when the DFS algorithm has finished.
  @protected
  void onTraversalFinished();

  void _addToStack(List<N> children) {
    final addToStack = children
        .expand((e) => [
              e, // step deeper
              null, // step back
            ])
        .toList()
        .reversed;
    _logger.finest('Adding to stack: $addToStack');
    _stack.addAll(addToStack);
  }
}

class SimpleDepthFirstSearchTreeIterator<T extends Tree<N>,
    N extends TreeNode<N>> extends DepthFirstSearchTreeIterator<T, N, N> {
  SimpleDepthFirstSearchTreeIterator(super.tree);

  @override
  void onStepIn(N node) {}

  @override
  void onStepOut() {}

  @override
  void onTraversalFinished() {}

  @override
  N transformNode(N node) => node;
}
