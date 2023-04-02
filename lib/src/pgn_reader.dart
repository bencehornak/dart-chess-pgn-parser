// ignore_for_file: non_constant_identifier_names

import 'package:antlr4/antlr4.dart';
import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/chess_pgn_parser.dart';
import 'package:chess_pgn_parser/src/chess_game_tags.dart';
import 'package:chess_pgn_parser/src/generated/PGNListener.dart';
import 'package:logging/logging.dart';

import 'generated/PGNLexer.dart';
import 'generated/PGNParser.dart';

class PgnReader {
  final InputStream _input;

  PgnReader.fromString(String input) : _input = InputStream.fromString(input);

  List<ChessHalfMoveTree> parse() {
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

  List<ChessHalfMoveTree> _parseDatabaseContext(
      Pgn_databaseContext databaseContext) {
    return databaseContext
        .pgn_games()
        .map((game) => _parseGameContext(game))
        .toList();
  }

  ChessHalfMoveTree _parseGameContext(Pgn_gameContext gameContext) {
    final tags = _parseGameTagSectionContext(gameContext);
    final rootNode = _parseGameMoveTextSectionContext(gameContext);
    return ChessHalfMoveTree(rootNode: rootNode, tags: tags);
  }

  ChessGameTags _parseGameTagSectionContext(Pgn_gameContext gameContext) {
    final tagSection = gameContext.tag_section();
    _assertWithContextFeedback(
        gameContext,
        tagSection != null && tagSection.children != null,
        'Tag section is missing');

    final rawTags = Map.fromEntries(tagSection!.tag_pairs().map((tagPair) {
      // Tag representation format:
      // [Black "Smith, John Q.:Woodpusher 2000"]

      // name is unescaped
      final name = tagPair.tag_name()!.text;

      // value is double-quoted
      final valueString = tagPair.tag_value()!.text;
      final valueStringRegexp = RegExp(r'^"([^"]*)"$');
      final valueStringMatch = valueStringRegexp.firstMatch(valueString);
      _assertWithContextFeedback(
          tagPair,
          valueStringMatch != null && valueStringMatch.group(1) != null,
          'Incorrect value representation');
      final valueStringWithoutQuotes = valueStringMatch!.group(1)!;

      return MapEntry(name, valueStringWithoutQuotes);
    }));

    return _addErrorContextIfThrows(
        tagSection, () => ChessGameTags.fromRawTags(rawTags));
  }

  ChessHalfMoveTreeNode _parseGameMoveTextSectionContext(
      Pgn_gameContext gameContext) {
    final movetextSection = gameContext.movetext_section();
    final listener = _MoveTextParseTreeListener();
    ParseTreeWalker.DEFAULT.walk(listener, movetextSection!);

    return listener.rootNode;
  }
}

class PgnReaderException implements Exception {
  final ParserRuleContext ctx;
  final String message;

  PgnReaderException(this.ctx, this.message);

  @override
  String toString() {
    return 'PgnReaderException: $message (at line ${ctx.start?.line} at position ${ctx.start?.charPositionInLine})\n'
        '${ctx.text}';
  }
}

class _MoveTextParseTreeListener extends PGNListener {
  static final _log = Logger('_MoveTextParseTreeListener');
  static final _fullMoveNumberIndicationRegExp = RegExp(r'^(\d+)\.$');
  static final _blackMoveNumberIndicationRegExp = RegExp(r'^(\d+)\.\.\.$');

  final Chess _board = Chess();
  final List<ChessHalfMoveTreeNode> nodeStack = [];
  final List<int> _variationLengthStack = [
    0 // main line
  ];

  /// The PGN notation allows a half-move jump back when opening variations,
  /// these jumps have to be noted down, so that they can be restored after the
  /// variation.
  ///
  /// Example:
  /// ```
  /// [...] 3. a3 a6 (3... a5) 4. Nc3 [...]
  /// ```
  ///
  /// Explanation: a5 comes after a3 (not a6), so a6 has to be stored for the
  /// time of the variation and has to be restored afterwards.
  ///
  /// If `null` is pushed to the end of the stack, it means that no node was
  /// popped before we went into the variation.
  final List<ChessHalfMoveTreeNode?> _poppedBeforeVariationStack = [];

  /// Variation depth.
  ///
  /// {@macro variation_depth}
  int _variationDepth = 0;

  final ChessHalfMoveTreeNode rootNode =
      ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit();

  @override
  void enterMovetext_section(Movetext_sectionContext ctx) {
    _log.finer('Entering move text section context');
    _log.finest('Adding rootNode to the nodeStack');

    nodeStack.add(rootNode);
  }

  @override
  void exitMovetext_section(Movetext_sectionContext ctx) {
    _log.finer('Exiting move text section context');
    _log.finest('Adding move ${nodeStack.first.move?.san} to the first moves');
    nodeStack.clear();
  }

  @override
  void enterFull_move_number_indication(
      Full_move_number_indicationContext ctx) {
    _checkMoveNumber(ctx, _fullMoveNumberIndicationRegExp);
    _assertWithContextFeedback(
        ctx, _board.turn == Color.WHITE, 'White move was expected');
    _log.finer('Full move number indicator: ${ctx.text}');
  }

  @override
  void enterBlack_move_number_indication(
      Black_move_number_indicationContext ctx) {
    _checkMoveNumber(ctx, _blackMoveNumberIndicationRegExp);
    _log.finer('Black move number indicator: ${ctx.text}');
  }

  void _checkMoveNumber(ParserRuleContext ctx, RegExp pattern) {
    final match = pattern.firstMatch(ctx.text);
    var actualMoveNumber = int.parse(match!.group(1)!);
    var expectedMoveNumber = _board.move_number;
    _assertWithContextFeedback(ctx, actualMoveNumber == expectedMoveNumber,
        'Invalid move number. Expected: $expectedMoveNumber. Got: $actualMoveNumber');
  }

  @override
  void enterSan_move(San_moveContext ctx) {
    _log.finer('SAN move: ${ctx.text}');
    final san = ctx.text;

    final nextMoves = _board.generate_moves();
    final move = nextMoves.firstWhere((move) => _board.move_to_san(move) == san,
        orElse: () => _failWithContextFeedback(ctx, 'Invalid move \'$san\''));

    int moveNumber = _board.move_number;
    _board.move(move);
    _log.finest('Board (move=${_board.move_number}):\n${_board.ascii}');

    final annotatedMove = AnnotatedMove.fromMove(move, moveNumber, san);
    final parent = nodeStack.last;
    final node = ChessHalfMoveTreeNode.withLateChildrenInit(
        move: annotatedMove, parent: parent, variationDepth: _variationDepth);
    parent.children.add(node);

    nodeStack.add(node);
    ++_variationLengthStack.last;
    _log.finest('Variation length: ${_variationLengthStack.last}');
  }

  @override
  void enterRecursive_variation(Recursive_variationContext ctx) {
    _log.finer('Entering recursive variation: ${ctx.text}');
    ++_variationDepth;
    _variationLengthStack.add(0);

    Color? firstMoveColorInVariation;
    var firstChildInVariation = ctx.getChild(1)!.getChild(0)!.getChild(0);
    if (firstChildInVariation is Full_move_number_indicationContext) {
      firstMoveColorInVariation = Color.WHITE;
    } else if (firstChildInVariation is Black_move_number_indicationContext) {
      firstMoveColorInVariation = Color.BLACK;
    } else {
      _assertWithContextFeedback(
          firstChildInVariation as ParserRuleContext,
          false,
          'The variation was expected to start with a move number indication');
    }

    _log.finest('First move color in variation: $firstMoveColorInVariation');

    // If the next player 'should be' white, but the variation starts with a
    // black move number indication, we have to pop the last move and redo it
    // after the variation. See the explanation of _poppedBeforeVariationStack.
    if (_board.turn != firstMoveColorInVariation!) {
      _board.undo_move();
      var poppedNode = nodeStack.removeLast();
      _poppedBeforeVariationStack.add(poppedNode);
      _log.finest(
          'First move color in variation does not match next move color => popped move ${poppedNode.move?.san}');
    } else {
      _poppedBeforeVariationStack.add(null);
      _log.finest(
          'First move color in variation matches next move color => not popping any move');
    }
  }

  @override
  void exitRecursive_variation(Recursive_variationContext ctx) {
    _log.finer('Exiting recursive variation: ${ctx.text}');
    --_variationDepth;
    final variationLength = _variationLengthStack.removeLast();

    // Do 'variationLength' times undo_move()
    _log.finest('Backtracking $variationLength time(s)');
    Iterable.generate(variationLength).forEach((i) {
      _board.undo_move();
      nodeStack.removeLast();
    });

    final poppedBeforeVariation = _poppedBeforeVariationStack.removeLast();

    if (poppedBeforeVariation != null) {
      nodeStack.add(poppedBeforeVariation);
      _board.move(poppedBeforeVariation.move);
      _log.finest(
          'Restored board to the pre-variation state (move=${_board.move_number}):\n${_board.ascii}');
    } else {
      _log.finest(
          'No node was popped before the variation, board already up-to-date (move=${_board.move_number}):\n${_board.ascii}');
    }
  }

  @override
  void enterBrace_comment(Brace_commentContext ctx) {
    _assertWithContextFeedback(ctx,
        nodeStack.isNotEmpty || nodeStack.last.rootNode, 'Unexpected comment');
    final commentWithBraces = ctx.text;
    final comment = commentWithBraces
        .replaceFirst(RegExp(r'^{'), '')
        .replaceFirst(RegExp(r'}$'), '');
    nodeStack.last.move!.comment = comment;
  }

  @override
  void noSuchMethod(Invocation invocation) {
    // just ignore the remaining events
  }
}

void _assertWithContextFeedback(
    ParserRuleContext ctx, bool condition, String message) {
  if (!condition) _failWithContextFeedback(ctx, message);
}

T _addErrorContextIfThrows<T>(ParserRuleContext ctx, T Function() body) {
  try {
    return body();
  } on Exception catch (error) {
    throw PgnReaderException(ctx, error.toString());
  }
}

Never _failWithContextFeedback(ParserRuleContext ctx, String message) =>
    throw PgnReaderException(ctx, message);
