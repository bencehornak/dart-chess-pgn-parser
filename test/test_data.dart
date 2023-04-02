import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';

ChessHalfMoveTree buildChessHalfMoveTree() => ChessHalfMoveTree(
    tags: buildChessGameTags(),
    rootNode: ChessHalfMoveTreeNode.rootNodeWithLateParentInit(
        // Depth: 1st half move
        children: [
          // d4
          ChessHalfMoveTreeNode.withLateParentInit(
            move: AnnotatedMove(
                color: Color.WHITE,
                from: Chess.SQUARES['d2'],
                to: Chess.SQUARES['d4'],
                piece: PieceType.PAWN,
                moveNumber: 1,
                san: 'd4'),
            variationDepth: 1,
            children: [],
          ),
          // e4
          ChessHalfMoveTreeNode.withLateParentInit(
              move: AnnotatedMove(
                  color: Color.WHITE,
                  from: Chess.SQUARES['e2'],
                  to: Chess.SQUARES['e4'],
                  piece: PieceType.PAWN,
                  moveNumber: 1,
                  san: 'e4'),
              variationDepth: 0,
              // Depth: 2nd half move
              children: [
                // e5
                ChessHalfMoveTreeNode.withLateParentInit(
                    move: AnnotatedMove(
                        color: Color.BLACK,
                        from: Chess.SQUARES['e7'],
                        to: Chess.SQUARES['e5'],
                        piece: PieceType.PAWN,
                        moveNumber: 1,
                        san: 'e5'),
                    variationDepth: 0,
                    children: [
                      // Nc3
                      ChessHalfMoveTreeNode.withLateParentInit(
                          move: AnnotatedMove(
                              color: Color.WHITE,
                              from: Chess.SQUARES['b1'],
                              to: Chess.SQUARES['c3'],
                              piece: PieceType.KNIGHT,
                              moveNumber: 2,
                              san: 'Nc3'),
                          variationDepth: 0,
                          children: [
                            // Nf6
                            ChessHalfMoveTreeNode.withLateParentInit(
                                move: AnnotatedMove(
                                    color: Color.BLACK,
                                    from: Chess.SQUARES['g8'],
                                    to: Chess.SQUARES['f6'],
                                    piece: PieceType.KNIGHT,
                                    moveNumber: 2,
                                    san: 'Nf6'),
                                variationDepth: 0,
                                children: []),
                          ]),
                    ]),
                // e6
                ChessHalfMoveTreeNode.withLateParentInit(
                    move: AnnotatedMove(
                        color: Color.BLACK,
                        from: Chess.SQUARES['e7'],
                        to: Chess.SQUARES['e6'],
                        piece: PieceType.PAWN,
                        moveNumber: 1,
                        san: 'e6'),
                    variationDepth: 1,
                    children: [])
              ])
        ]))
  ..fixParentsRecursively();

ChessGameTags buildChessGameTags({
  Map<String, String>? overrides,
  List<String>? removeTags,
}) =>
    ChessGameTags.fromRawTags(
      {
        'Event': 'Test',
        'Site': 'Test Site',
        'Date': '2023.03.06',
        'Round': '23',
        'White': 'Bence Hornák:His friends',
        'Black': 'Bence Hornák',
        'Result': '*',
      }
        ..addAll(overrides ?? {})
        ..removeWhere((key, value) => (removeTags ?? []).contains(key)),
    );
