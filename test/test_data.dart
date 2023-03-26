import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';

ChessHalfMoveTree buildChessHalfMoveTree() => ChessHalfMoveTree(
        tags: {
          'Event': ['Test'],
          'Site': ['Test Site'],
          'Date': ['2023.03.06'],
          'Round': ['-'],
          'White': ['Bence Hornák', 'His friends'],
          'Black': ['Bence Hornák'],
          'Result': ['*'],
        },
        rootNode: ChessHalfMoveTreeNode.rootNodeWithLateParentInit(
            // Depth: 1st half move
            children: [
              // d4
              ChessHalfMoveTreeNode.withLateParentInit(
                move: AnnotatedMove(
                    Color.WHITE,
                    Chess.SQUARES['d2'],
                    Chess.SQUARES['d4'],
                    0,
                    PieceType.PAWN,
                    null,
                    null,
                    1,
                    'd4'),
                variationDepth: 1,
                children: [],
              ),
              // e4
              ChessHalfMoveTreeNode.withLateParentInit(
                  move: AnnotatedMove(
                      Color.WHITE,
                      Chess.SQUARES['e2'],
                      Chess.SQUARES['e4'],
                      0,
                      PieceType.PAWN,
                      null,
                      null,
                      1,
                      'e4'),
                  variationDepth: 0,
                  // Depth: 2nd half move
                  children: [
                    // e5
                    ChessHalfMoveTreeNode.withLateParentInit(
                        move: AnnotatedMove(
                            Color.BLACK,
                            Chess.SQUARES['e7'],
                            Chess.SQUARES['e5'],
                            0,
                            PieceType.PAWN,
                            null,
                            null,
                            1,
                            'e5'),
                        variationDepth: 0,
                        children: [
                          // Nc3
                          ChessHalfMoveTreeNode.withLateParentInit(
                              move: AnnotatedMove(
                                  Color.WHITE,
                                  Chess.SQUARES['b1'],
                                  Chess.SQUARES['c3'],
                                  0,
                                  PieceType.KNIGHT,
                                  null,
                                  null,
                                  2,
                                  'Nc3'),
                              variationDepth: 0,
                              children: [
                                // Nf6
                                ChessHalfMoveTreeNode.withLateParentInit(
                                    move: AnnotatedMove(
                                        Color.BLACK,
                                        Chess.SQUARES['g8'],
                                        Chess.SQUARES['f6'],
                                        0,
                                        PieceType.KNIGHT,
                                        null,
                                        null,
                                        2,
                                        'Nf6'),
                                    variationDepth: 0,
                                    children: []),
                              ]),
                        ]),
                    // e6
                    ChessHalfMoveTreeNode.withLateParentInit(
                        move: AnnotatedMove(
                            Color.BLACK,
                            Chess.SQUARES['e7'],
                            Chess.SQUARES['e6'],
                            0,
                            PieceType.PAWN,
                            null,
                            null,
                            1,
                            'e6'),
                        variationDepth: 1,
                        children: [])
                  ])
            ]))
      ..fixParentsRecursively();
