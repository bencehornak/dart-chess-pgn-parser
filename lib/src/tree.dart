import 'package:chess/chess.dart';

class AnnotatedMove extends Move {
  AnnotatedMove(super.color, super.from, super.to, super.flags, super.piece,
      super.captured, super.promotion);
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
    List<GameNode> stack = [];
    stack.addAll(firstMoves.reversed);
    while (stack.isNotEmpty) {
      GameNode node = stack.removeLast();
      callback(
        Chess(), // TODO implement
        node.move,
        node.children.map((child) => child.move).toList(),
      );
      stack.addAll(node.children.reversed);
    }
  }
}

class GameNode {
  final AnnotatedMove move;
  final List<GameNode> children;

  GameNode(this.move, List<GameNode> children)
      : children = List.unmodifiable(children);
}
