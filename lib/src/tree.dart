import 'package:chess/chess.dart';

class AnnotatedMove extends Move {
  AnnotatedMove(super.color, super.from, super.to, super.flags, super.piece,
      super.captured, super.promotion);
}

class GameWithVariations {
  final List<GameNode> firstMoves;

  GameWithVariations(List<GameNode> firstMoves)
      : firstMoves = List.unmodifiable(firstMoves);

  void traverse(
      void Function(Chess board, AnnotatedMove lastMove,
              List<AnnotatedMove> nextMoves)
          callback) {
    throw UnimplementedError();
  }
}

class GameNode {
  final AnnotatedMove move;
  final List<GameNode> children;

  GameNode(this.move, List<GameNode> children)
      : children = List.unmodifiable(children);
}
