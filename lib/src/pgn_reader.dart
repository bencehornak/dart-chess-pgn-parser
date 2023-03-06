import 'package:antlr4/antlr4.dart';
import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:chess_pgn_parser/src/generated/PGNListener.dart';

import 'generated/PGNLexer.dart';
import 'generated/PGNParser.dart';

class PgnReader {
  final InputStream _input;

  PgnReader.fromString(String input) : _input = InputStream.fromString(input);

  List<GameWithVariations> parse() {
    final databaseContext = _parseToAntlrTree();
    return _parseDatabaseContext(databaseContext);
  }

  Pgn_databaseContext _parseToAntlrTree() {
    final lexer = PGNLexer(_input);
    final tokens = CommonTokenStream(lexer);
    final parser = PGNParser(tokens);
    parser.addErrorListener(DiagnosticErrorListener());
    parser.buildParseTree = true;
    return parser.pgn_database();
  }

  List<GameWithVariations> _parseDatabaseContext(
      Pgn_databaseContext databaseContext) {
    return databaseContext
        .pgn_games()
        .map((game) => _parseGameContext(game))
        .toList();
  }

  GameWithVariations _parseGameContext(Pgn_gameContext gameContext) {
    final firstMoves = _parseGameMoveTextSectionContext(gameContext);
    return GameWithVariations(firstMoves);
  }

  List<GameNode> _parseGameMoveTextSectionContext(Pgn_gameContext gameContext) {
    final movetextSection = gameContext.movetext_section();
    final listener = _MoveTextParseTreeListener();
    ParseTreeWalker.DEFAULT.walk(listener, movetextSection!);

    return listener.firstMoves;
  }
}

class _MoveTextParseTreeListener extends PGNListener {
  final Chess _board = Chess();
  final List<GameNode> nodeStack = [];
  final List<int> _variationLengthStack = [
    0 // main line
  ];

  final List<GameNode> firstMoves = [];

  @override
  void enterSan_move(San_moveContext ctx) {
    final san = ctx.text;

    final nextMoves = _board.generate_moves();
    final move =
        nextMoves.firstWhere((move) => _board.move_to_san(move) == san);

    _board.move(move);

    final annotatedMove = AnnotatedMove.fromMove(move);
    final node = GameNode(annotatedMove, []);
    if (nodeStack.isNotEmpty) {
      final parent = nodeStack.last;
      parent.children.add(node);
    }
    nodeStack.add(node);
    ++_variationLengthStack.last;
  }

  @override
  void enterRecursive_variation(Recursive_variationContext ctx) {
    _variationLengthStack.add(0);
  }

  @override
  void exitRecursive_variation(Recursive_variationContext ctx) {
    final variationLength = _variationLengthStack.removeLast();

    // Do 'variationLength' times undo_move()
    // ignore: avoid_function_literals_in_foreach_calls
    Iterable.generate(variationLength).forEach((i) {
      _board.undo_move();
    });

    final node = nodeStack.removeLast();
    if (nodeStack.isEmpty) {
      firstMoves.add(node);
    }
  }

  @override
  void noSuchMethod(Invocation invocation) {
    // just ignore the remaining events
  }
}
