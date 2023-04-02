import 'package:chess/chess.dart';

class Arrow {
  final ArrowColor color;
  final int from;
  final int to;

  Arrow({
    required this.color,
    required this.from,
    required this.to,
  });

  factory Arrow.fromPGN(String string) {
    final color = _parseColor(string.substring(0, 1));
    final from = Chess.SQUARES[string.substring(1, 3)]!;
    final to = Chess.SQUARES[string.substring(3, 5)];
    if (string.length == 3) {
      return Arrow(color: color, from: from, to: from);
    }
    if (string.length == 5 && to != null) {
      return Arrow(color: color, from: from, to: to);
    }
    throw AssertionError('Cannot parse arrow');
  }
  static ArrowColor _parseColor(String color) {
    final map = <String, ArrowColor>{
      'G': ArrowColor.green,
      'R': ArrowColor.red,
      'Y': ArrowColor.yellow,
      'B': ArrowColor.blue,
    };
    return map[color]!;
  }
}

enum ArrowColor { green, red, yellow, blue }
