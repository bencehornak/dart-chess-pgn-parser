import 'package:chess/chess.dart';

abstract class VisualAnnotation {
  final VisualAnnotationColor color;

  VisualAnnotation({required this.color});

  factory VisualAnnotation.fromPGN(String string) {
    final color = _parseColor(string.substring(0, 1));
    if (string.length == 3) {
      final square = Chess.SQUARES[string.substring(1, 3)]!;
      return HighlightedSquare(color: color, square: square);
    } else if (string.length == 5) {
      final from = Chess.SQUARES[string.substring(1, 3)]!;
      final to = Chess.SQUARES[string.substring(3, 5)];
      return Arrow(color: color, from: from, to: to);
    } else {
      throw AssertionError('Cannot parse arrow');
    }
  }
  static VisualAnnotationColor _parseColor(String color) {
    final map = <String, VisualAnnotationColor>{
      'G': VisualAnnotationColor.green,
      'R': VisualAnnotationColor.red,
      'Y': VisualAnnotationColor.yellow,
      'B': VisualAnnotationColor.blue,
    };
    return map[color]!;
  }
}

class HighlightedSquare extends VisualAnnotation {
  final int square;

  HighlightedSquare({required super.color, required this.square});

  @override
  String toString() => 'HighlightedSquare(color: $color, square: $square)';

  @override
  bool operator ==(dynamic other) =>
      other is HighlightedSquare &&
      color == other.color &&
      square == other.square;

  @override
  int get hashCode => Object.hash(color, square);
}

class Arrow extends VisualAnnotation {
  final int from;
  final int to;

  Arrow({
    required super.color,
    required this.from,
    required this.to,
  });

  @override
  String toString() => 'Arrow(color: $color, from: $from, to: $to)';

  @override
  bool operator ==(dynamic other) =>
      other is Arrow &&
      color == other.color &&
      from == other.from &&
      to == other.to;

  @override
  int get hashCode => Object.hash(color, from, to);
}

enum VisualAnnotationColor { green, red, yellow, blue }
