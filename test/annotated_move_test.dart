import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:test/test.dart';

void main() {
  final firstWhiteMove = AnnotatedMove(
      color: Color.WHITE,
      from: Chess.SQUARES['e2'],
      to: Chess.SQUARES['e4'],
      piece: PieceType.PAWN,
      moveNumber: 1,
      san: 'e4');
  final firstBlackMove = AnnotatedMove(
      color: Color.BLACK,
      from: Chess.SQUARES['e7'],
      to: Chess.SQUARES['e5'],
      piece: PieceType.PAWN,
      moveNumber: 1,
      san: 'e5');
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
