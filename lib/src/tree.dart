import 'package:chess/chess.dart';

class AnnotatedMove extends Move {
  // Let's cache the SAN notation for better performance
  String san;

  AnnotatedMove(
    super.color,
    super.from,
    super.to,
    super.flags,
    super.piece,
    super.captured,
    super.promotion,
    this.san,
  );

  AnnotatedMove.fromMove(Move move, String san)
      : this(
          move.color,
          move.from,
          move.to,
          move.flags,
          move.piece,
          move.captured,
          move.promotion,
          san,
        );

  @override
  String toString() => san;
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
        board.undo_move();
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

  @override
  String toString() {
    String formatMove(Color color, int moveNumber, String san) {
      Color lastMoveColor = color == Color.WHITE ? Color.BLACK : Color.WHITE;
      if (lastMoveColor == Color.BLACK) {
        // The moveNumber is increased before black in the chess lib. It is
        // probably a bug.
        --moveNumber;
      }
      final dots = lastMoveColor == Color.WHITE ? '.' : '...';
      final halfMoveNumber =
          (moveNumber - 1) * 2 + (lastMoveColor == Color.BLACK ? 1 : 0);
      return '${'  ' * (halfMoveNumber)}$moveNumber$dots $san';
    }

    final buffer = StringBuffer();
    buffer.write('GameWithVariations(\n');
    traverse((board, lastMove, nextMoves) {
      buffer.write(
          '  ${formatMove(board.turn, board.move_number, lastMove.san)}\n');
    });
    buffer.write(')');
    return buffer.toString();
  }
}

class GameNode {
  final AnnotatedMove move;
  final List<GameNode> children;

  GameNode(this.move, this.children);
}
