import 'package:chess/chess.dart';

class AnnotatedMove extends Move {
  // Let's cache the moveNumber and the SAN notation for better performance
  final int moveNumber;
  final String san;

  /// Returns the number of half moves in the game, including this one.
  ///
  /// Do not confuse it with [Chess.half_moves], which is a counter for the [50
  /// move rule](https://en.wikipedia.org/wiki/Fifty-move_rule).
  ///
  /// For the first white move it is `1`, for the first black move it is `2` and
  /// so on.
  int get totalHalfMoveNumber =>
      (moveNumber - 1) * 2 + (color == Color.BLACK ? 1 : 0) + 1;

  String get moveNumberIndicator =>
      color == Color.WHITE ? '$moveNumber.' : '$moveNumber...';

  AnnotatedMove(
    super.color,
    super.from,
    super.to,
    super.flags,
    super.piece,
    super.captured,
    super.promotion,
    this.moveNumber,
    this.san,
  );

  AnnotatedMove.fromMove(Move move, int moveNumber, String san)
      : this(
          move.color,
          move.from,
          move.to,
          move.flags,
          move.piece,
          move.captured,
          move.promotion,
          moveNumber,
          san,
        );

  @override
  String toString() => toHumanReadable();

  String toHumanReadable({bool showBlackMoveNumberIndicator = true}) {
    final showMoveNumberIndicator =
        color == Color.WHITE || showBlackMoveNumberIndicator;

    return '${showMoveNumberIndicator ? '$moveNumberIndicator ' : ''}$san';
  }
}
