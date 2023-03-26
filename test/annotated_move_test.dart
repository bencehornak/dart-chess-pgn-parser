import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:test/test.dart';

void main() {
  final firstWhiteMove = AnnotatedMove(Color.WHITE, Chess.SQUARES['e2'],
      Chess.SQUARES['e4'], 0, PieceType.PAWN, null, null, 1, 'e4');
  final firstBlackMove = AnnotatedMove(Color.BLACK, Chess.SQUARES['e7'],
      Chess.SQUARES['e5'], 0, PieceType.PAWN, null, null, 1, 'e5');
  group('moveNumberIndicator', () {
    test('First white move', () {
      expect(firstWhiteMove.moveNumberIndicator, '1.');
    });
    test('First black move', () {
      expect(firstBlackMove.moveNumberIndicator, '1...');
    });
  });
  group('totalHalfMoveNumber', () {
    test('First white move', () {
      expect(firstWhiteMove.totalHalfMoveNumber, 1);
    });
    test('First black move', () {
      expect(firstBlackMove.totalHalfMoveNumber, 2);
    });
  });
  group('toHumanReadable', () {
    test('White', () {
      expect(firstWhiteMove.toHumanReadable(), '1. e4');
    });
    test('Black (showBlackMoveNumberIndicator: true)', () {
      expect(firstBlackMove.toHumanReadable(showBlackMoveNumberIndicator: true),
          '1... e5');
    });
    test('Black (showBlackMoveNumberIndicator: false)', () {
      expect(
          firstBlackMove.toHumanReadable(showBlackMoveNumberIndicator: false),
          'e5');
    });
  });
}
