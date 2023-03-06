import 'package:chess/chess.dart';

class AnnotatedMove extends Move {
  AnnotatedMove(super.color, super.from, super.to, super.flags, super.piece,
      super.captured, super.promotion);
  AnnotatedMove.fromMove(Move move)
      : this(
          move.color,
          move.from,
          move.to,
          move.flags,
          move.piece,
          move.captured,
          move.promotion,
        );
}

class GameWithVariations {
  final List<GameNode> firstMoves;

  GameWithVariations(List<GameNode> firstMoves)
      : firstMoves = List.unmodifiable(firstMoves);

  /// Traverse the tree in DFS order.
  void traverse(
      void Function(Chess board, AnnotatedMove lastMove,
              List<AnnotatedMove> nextMoves)
          callback) {
    final board = Chess();

    // A stack data structure used by the DFS algorithm.
    //
    // It contains:
    //   1. GameNode objects, whose meaning is to step one level deeper in the
    //      tree in the corresponding direction
    //   2. nulls, which encode to step one level back in the tree
    //
    // The last element of the stack will be the next one being visited, that's
    // why elements are added in reverse order.
    List<GameNode?> stack = [];
    void addToStack(List<GameNode> children) {
      stack.addAll(children
          .expand((e) => [
                e, // step deeper
                null, // step back
              ])
          .toList()
          .reversed);
    }

    addToStack(firstMoves);
    while (stack.isNotEmpty) {
      GameNode? node = stack.removeLast();
      if (node == null) {
        board.undo();
      } else {
        board.move(node.move);
        callback(
          board,
          node.move,
          node.children.map((child) => child.move).toList(),
        );
        addToStack(node.children);
      }
    }

    assert(board.move_number == 1,
        'We should arrive back to the start after performing the DFS');
  }
}

class GameNode {
  final AnnotatedMove move;
  final List<GameNode> children;

  GameNode(this.move, this.children);
}
