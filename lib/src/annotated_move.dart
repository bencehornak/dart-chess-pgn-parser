import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/evaluation.dart';
import 'package:chess_pgn_parser/src/shape.dart';

class AnnotatedMove extends Move {
  // Let's cache the moveNumber and the SAN notation for better performance
  final int moveNumber;
  final String san;
  String? comment;

  double? elapsedMoveTime;
  double? clock;
  Evaluation? evaluation;
  final List<VisualAnnotation> visualAnnotations = [];

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

  AnnotatedMove({
    required Color color,
    required int from,
    required int to,
    int flags = 0,
    required PieceType piece,
    PieceType? captured,
    PieceType? promotion,
    required this.moveNumber,
    required this.san,
    this.elapsedMoveTime,
    this.clock,
    this.evaluation,
  }) : super(color, from, to, flags, piece, captured, promotion);

  AnnotatedMove.fromMove(
    Move move, {
    required int moveNumber,
    required String san,
    double? elapsedMoveTime,
    double? clock,
    Evaluation? evaluation,
  }) : this(
          color: move.color,
          from: move.from,
          to: move.to,
          flags: move.flags,
          piece: move.piece,
          captured: move.captured,
          promotion: move.promotion,
          moveNumber: moveNumber,
          san: san,
          elapsedMoveTime: elapsedMoveTime,
          clock: clock,
          evaluation: evaluation,
        );

  @override
  String toString() => toHumanReadable();

  String toHumanReadable({bool showBlackMoveNumberIndicator = true}) {
    final showMoveNumberIndicator =
        color == Color.WHITE || showBlackMoveNumberIndicator;

    return '${showMoveNumberIndicator ? '$moveNumberIndicator ' : ''}$san';
  }
}
