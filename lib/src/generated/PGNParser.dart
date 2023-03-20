// Generated from antlr4/PGN.g4 by ANTLR 4.12.0
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';

import 'PGNListener.dart';
import 'PGNBaseListener.dart';
const int RULE_parse = 0, RULE_pgn_database = 1, RULE_pgn_game = 2, RULE_tag_section = 3, 
          RULE_tag_pair = 4, RULE_tag_name = 5, RULE_tag_value = 6, RULE_movetext_section = 7, 
          RULE_element_sequence = 8, RULE_element = 9, RULE_full_move_number_indication = 10, 
          RULE_black_move_number_indication = 11, RULE_san_move = 12, RULE_recursive_variation = 13, 
          RULE_game_termination = 14, RULE_brace_comment = 15;
class PGNParser extends Parser {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.12.0', RuntimeMetaData.VERSION);
  static const int TOKEN_EOF = IntStream.EOF;

  static final List<DFA> _decisionToDFA = List.generate(
      _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int TOKEN_WHITE_WINS = 1, TOKEN_BLACK_WINS = 2, TOKEN_DRAWN_GAME = 3, 
                   TOKEN_REST_OF_LINE_COMMENT = 4, TOKEN_BRACE_COMMENT = 5, 
                   TOKEN_ESCAPE = 6, TOKEN_SPACES = 7, TOKEN_STRING = 8, 
                   TOKEN_INTEGER = 9, TOKEN_PERIOD = 10, TOKEN_ASTERISK = 11, 
                   TOKEN_LEFT_BRACKET = 12, TOKEN_RIGHT_BRACKET = 13, TOKEN_LEFT_BRACE = 14, 
                   TOKEN_RIGHT_BRACE = 15, TOKEN_LEFT_PARENTHESIS = 16, 
                   TOKEN_RIGHT_PARENTHESIS = 17, TOKEN_LEFT_ANGLE_BRACKET = 18, 
                   TOKEN_RIGHT_ANGLE_BRACKET = 19, TOKEN_NUMERIC_ANNOTATION_GLYPH = 20, 
                   TOKEN_SYMBOL = 21, TOKEN_SUFFIX_ANNOTATION = 22;

  @override
  final List<String> ruleNames = [
    'parse', 'pgn_database', 'pgn_game', 'tag_section', 'tag_pair', 'tag_name', 
    'tag_value', 'movetext_section', 'element_sequence', 'element', 'full_move_number_indication', 
    'black_move_number_indication', 'san_move', 'recursive_variation', 'game_termination', 
    'brace_comment'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'1-0'", "'0-1'", "'1/2-1/2'", null, null, null, null, null, 
      null, "'.'", "'*'", "'['", "']'", "'{'", "'}'", "'('", "')'", "'<'", 
      "'>'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, "WHITE_WINS", "BLACK_WINS", "DRAWN_GAME", "REST_OF_LINE_COMMENT", 
      "BRACE_COMMENT", "ESCAPE", "SPACES", "STRING", "INTEGER", "PERIOD", 
      "ASTERISK", "LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_BRACE", "RIGHT_BRACE", 
      "LEFT_PARENTHESIS", "RIGHT_PARENTHESIS", "LEFT_ANGLE_BRACKET", "RIGHT_ANGLE_BRACKET", 
      "NUMERIC_ANNOTATION_GLYPH", "SYMBOL", "SUFFIX_ANNOTATION"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }

  @override
  String get grammarFileName => 'PGN.g4';

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  ATN getATN() {
   return _ATN;
  }

  PGNParser(TokenStream input) : super(input) {
    interpreter = ParserATNSimulator(this, _ATN, _decisionToDFA, _sharedContextCache);
  }

  ParseContext parse() {
    dynamic _localctx = ParseContext(context, state);
    enterRule(_localctx, 0, RULE_parse);
    try {
      enterOuterAlt(_localctx, 1);
      state = 32;
      pgn_database();
      state = 33;
      match(TOKEN_EOF);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Pgn_databaseContext pgn_database() {
    dynamic _localctx = Pgn_databaseContext(context, state);
    enterRule(_localctx, 2, RULE_pgn_database);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 38;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while ((((_la) & ~0x3f) == 0 && ((1 << _la) & 3217966) != 0)) {
        state = 35;
        pgn_game();
        state = 40;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Pgn_gameContext pgn_game() {
    dynamic _localctx = Pgn_gameContext(context, state);
    enterRule(_localctx, 4, RULE_pgn_game);
    try {
      enterOuterAlt(_localctx, 1);
      state = 41;
      tag_section();
      state = 42;
      movetext_section();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Tag_sectionContext tag_section() {
    dynamic _localctx = Tag_sectionContext(context, state);
    enterRule(_localctx, 6, RULE_tag_section);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 47;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while (_la == TOKEN_LEFT_BRACKET) {
        state = 44;
        tag_pair();
        state = 49;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Tag_pairContext tag_pair() {
    dynamic _localctx = Tag_pairContext(context, state);
    enterRule(_localctx, 8, RULE_tag_pair);
    try {
      enterOuterAlt(_localctx, 1);
      state = 50;
      match(TOKEN_LEFT_BRACKET);
      state = 51;
      tag_name();
      state = 52;
      tag_value();
      state = 53;
      match(TOKEN_RIGHT_BRACKET);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Tag_nameContext tag_name() {
    dynamic _localctx = Tag_nameContext(context, state);
    enterRule(_localctx, 10, RULE_tag_name);
    try {
      enterOuterAlt(_localctx, 1);
      state = 55;
      match(TOKEN_SYMBOL);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Tag_valueContext tag_value() {
    dynamic _localctx = Tag_valueContext(context, state);
    enterRule(_localctx, 12, RULE_tag_value);
    try {
      enterOuterAlt(_localctx, 1);
      state = 57;
      match(TOKEN_STRING);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Movetext_sectionContext movetext_section() {
    dynamic _localctx = Movetext_sectionContext(context, state);
    enterRule(_localctx, 14, RULE_movetext_section);
    try {
      enterOuterAlt(_localctx, 1);
      state = 59;
      element_sequence();
      state = 60;
      game_termination();
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Element_sequenceContext element_sequence() {
    dynamic _localctx = Element_sequenceContext(context, state);
    enterRule(_localctx, 16, RULE_element_sequence);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 66;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      while ((((_la) & ~0x3f) == 0 && ((1 << _la) & 3211808) != 0)) {
        state = 64;
        errorHandler.sync(this);
        switch (tokenStream.LA(1)!) {
        case TOKEN_BRACE_COMMENT:
        case TOKEN_INTEGER:
        case TOKEN_NUMERIC_ANNOTATION_GLYPH:
        case TOKEN_SYMBOL:
          state = 62;
          element();
          break;
        case TOKEN_LEFT_PARENTHESIS:
          state = 63;
          recursive_variation();
          break;
        default:
          throw NoViableAltException(this);
        }
        state = 68;
        errorHandler.sync(this);
        _la = tokenStream.LA(1)!;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  ElementContext element() {
    dynamic _localctx = ElementContext(context, state);
    enterRule(_localctx, 18, RULE_element);
    try {
      state = 74;
      errorHandler.sync(this);
      switch (interpreter!.adaptivePredict(tokenStream, 4, context)) {
      case 1:
        enterOuterAlt(_localctx, 1);
        state = 69;
        full_move_number_indication();
        break;
      case 2:
        enterOuterAlt(_localctx, 2);
        state = 70;
        black_move_number_indication();
        break;
      case 3:
        enterOuterAlt(_localctx, 3);
        state = 71;
        san_move();
        break;
      case 4:
        enterOuterAlt(_localctx, 4);
        state = 72;
        brace_comment();
        break;
      case 5:
        enterOuterAlt(_localctx, 5);
        state = 73;
        match(TOKEN_NUMERIC_ANNOTATION_GLYPH);
        break;
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Full_move_number_indicationContext full_move_number_indication() {
    dynamic _localctx = Full_move_number_indicationContext(context, state);
    enterRule(_localctx, 20, RULE_full_move_number_indication);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 76;
      match(TOKEN_INTEGER);
      state = 78;
      errorHandler.sync(this);
      _la = tokenStream.LA(1)!;
      if (_la == TOKEN_PERIOD) {
        state = 77;
        match(TOKEN_PERIOD);
      }

    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Black_move_number_indicationContext black_move_number_indication() {
    dynamic _localctx = Black_move_number_indicationContext(context, state);
    enterRule(_localctx, 22, RULE_black_move_number_indication);
    try {
      enterOuterAlt(_localctx, 1);
      state = 80;
      match(TOKEN_INTEGER);
      state = 81;
      match(TOKEN_PERIOD);
      state = 82;
      match(TOKEN_PERIOD);
      state = 83;
      match(TOKEN_PERIOD);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  San_moveContext san_move() {
    dynamic _localctx = San_moveContext(context, state);
    enterRule(_localctx, 24, RULE_san_move);
    try {
      enterOuterAlt(_localctx, 1);
      state = 85;
      match(TOKEN_SYMBOL);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Recursive_variationContext recursive_variation() {
    dynamic _localctx = Recursive_variationContext(context, state);
    enterRule(_localctx, 26, RULE_recursive_variation);
    try {
      enterOuterAlt(_localctx, 1);
      state = 87;
      match(TOKEN_LEFT_PARENTHESIS);
      state = 88;
      element_sequence();
      state = 89;
      match(TOKEN_RIGHT_PARENTHESIS);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Game_terminationContext game_termination() {
    dynamic _localctx = Game_terminationContext(context, state);
    enterRule(_localctx, 28, RULE_game_termination);
    int _la;
    try {
      enterOuterAlt(_localctx, 1);
      state = 91;
      _la = tokenStream.LA(1)!;
      if (!((((_la) & ~0x3f) == 0 && ((1 << _la) & 2062) != 0))) {
      errorHandler.recoverInline(this);
      } else {
        if ( tokenStream.LA(1)! == IntStream.EOF ) matchedEOF = true;
        errorHandler.reportMatch(this);
        consume();
      }
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  Brace_commentContext brace_comment() {
    dynamic _localctx = Brace_commentContext(context, state);
    enterRule(_localctx, 30, RULE_brace_comment);
    try {
      enterOuterAlt(_localctx, 1);
      state = 93;
      match(TOKEN_BRACE_COMMENT);
    } on RecognitionException catch (re) {
      _localctx.exception = re;
      errorHandler.reportError(this, re);
      errorHandler.recover(this, re);
    } finally {
      exitRule();
    }
    return _localctx;
  }

  static const List<int> _serializedATN = [
      4,1,22,96,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,6,7,6,
      2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,13,2,
      14,7,14,2,15,7,15,1,0,1,0,1,0,1,1,5,1,37,8,1,10,1,12,1,40,9,1,1,2,
      1,2,1,2,1,3,5,3,46,8,3,10,3,12,3,49,9,3,1,4,1,4,1,4,1,4,1,4,1,5,1,
      5,1,6,1,6,1,7,1,7,1,7,1,8,1,8,5,8,65,8,8,10,8,12,8,68,9,8,1,9,1,9,
      1,9,1,9,1,9,3,9,75,8,9,1,10,1,10,3,10,79,8,10,1,11,1,11,1,11,1,11,
      1,11,1,12,1,12,1,13,1,13,1,13,1,13,1,14,1,14,1,15,1,15,1,15,0,0,16,
      0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,0,1,2,0,1,3,11,11,88,0,
      32,1,0,0,0,2,38,1,0,0,0,4,41,1,0,0,0,6,47,1,0,0,0,8,50,1,0,0,0,10,
      55,1,0,0,0,12,57,1,0,0,0,14,59,1,0,0,0,16,66,1,0,0,0,18,74,1,0,0,0,
      20,76,1,0,0,0,22,80,1,0,0,0,24,85,1,0,0,0,26,87,1,0,0,0,28,91,1,0,
      0,0,30,93,1,0,0,0,32,33,3,2,1,0,33,34,5,0,0,1,34,1,1,0,0,0,35,37,3,
      4,2,0,36,35,1,0,0,0,37,40,1,0,0,0,38,36,1,0,0,0,38,39,1,0,0,0,39,3,
      1,0,0,0,40,38,1,0,0,0,41,42,3,6,3,0,42,43,3,14,7,0,43,5,1,0,0,0,44,
      46,3,8,4,0,45,44,1,0,0,0,46,49,1,0,0,0,47,45,1,0,0,0,47,48,1,0,0,0,
      48,7,1,0,0,0,49,47,1,0,0,0,50,51,5,12,0,0,51,52,3,10,5,0,52,53,3,12,
      6,0,53,54,5,13,0,0,54,9,1,0,0,0,55,56,5,21,0,0,56,11,1,0,0,0,57,58,
      5,8,0,0,58,13,1,0,0,0,59,60,3,16,8,0,60,61,3,28,14,0,61,15,1,0,0,0,
      62,65,3,18,9,0,63,65,3,26,13,0,64,62,1,0,0,0,64,63,1,0,0,0,65,68,1,
      0,0,0,66,64,1,0,0,0,66,67,1,0,0,0,67,17,1,0,0,0,68,66,1,0,0,0,69,75,
      3,20,10,0,70,75,3,22,11,0,71,75,3,24,12,0,72,75,3,30,15,0,73,75,5,
      20,0,0,74,69,1,0,0,0,74,70,1,0,0,0,74,71,1,0,0,0,74,72,1,0,0,0,74,
      73,1,0,0,0,75,19,1,0,0,0,76,78,5,9,0,0,77,79,5,10,0,0,78,77,1,0,0,
      0,78,79,1,0,0,0,79,21,1,0,0,0,80,81,5,9,0,0,81,82,5,10,0,0,82,83,5,
      10,0,0,83,84,5,10,0,0,84,23,1,0,0,0,85,86,5,21,0,0,86,25,1,0,0,0,87,
      88,5,16,0,0,88,89,3,16,8,0,89,90,5,17,0,0,90,27,1,0,0,0,91,92,7,0,
      0,0,92,29,1,0,0,0,93,94,5,5,0,0,94,31,1,0,0,0,6,38,47,64,66,74,78
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}
class ParseContext extends ParserRuleContext {
  Pgn_databaseContext? pgn_database() => getRuleContext<Pgn_databaseContext>(0);
  TerminalNode? EOF() => getToken(PGNParser.TOKEN_EOF, 0);
  ParseContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_parse;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterParse(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitParse(this);
  }
}

class Pgn_databaseContext extends ParserRuleContext {
  List<Pgn_gameContext> pgn_games() => getRuleContexts<Pgn_gameContext>();
  Pgn_gameContext? pgn_game(int i) => getRuleContext<Pgn_gameContext>(i);
  Pgn_databaseContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_pgn_database;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterPgn_database(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitPgn_database(this);
  }
}

class Pgn_gameContext extends ParserRuleContext {
  Tag_sectionContext? tag_section() => getRuleContext<Tag_sectionContext>(0);
  Movetext_sectionContext? movetext_section() => getRuleContext<Movetext_sectionContext>(0);
  Pgn_gameContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_pgn_game;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterPgn_game(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitPgn_game(this);
  }
}

class Tag_sectionContext extends ParserRuleContext {
  List<Tag_pairContext> tag_pairs() => getRuleContexts<Tag_pairContext>();
  Tag_pairContext? tag_pair(int i) => getRuleContext<Tag_pairContext>(i);
  Tag_sectionContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_tag_section;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterTag_section(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitTag_section(this);
  }
}

class Tag_pairContext extends ParserRuleContext {
  TerminalNode? LEFT_BRACKET() => getToken(PGNParser.TOKEN_LEFT_BRACKET, 0);
  Tag_nameContext? tag_name() => getRuleContext<Tag_nameContext>(0);
  Tag_valueContext? tag_value() => getRuleContext<Tag_valueContext>(0);
  TerminalNode? RIGHT_BRACKET() => getToken(PGNParser.TOKEN_RIGHT_BRACKET, 0);
  Tag_pairContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_tag_pair;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterTag_pair(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitTag_pair(this);
  }
}

class Tag_nameContext extends ParserRuleContext {
  TerminalNode? SYMBOL() => getToken(PGNParser.TOKEN_SYMBOL, 0);
  Tag_nameContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_tag_name;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterTag_name(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitTag_name(this);
  }
}

class Tag_valueContext extends ParserRuleContext {
  TerminalNode? STRING() => getToken(PGNParser.TOKEN_STRING, 0);
  Tag_valueContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_tag_value;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterTag_value(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitTag_value(this);
  }
}

class Movetext_sectionContext extends ParserRuleContext {
  Element_sequenceContext? element_sequence() => getRuleContext<Element_sequenceContext>(0);
  Game_terminationContext? game_termination() => getRuleContext<Game_terminationContext>(0);
  Movetext_sectionContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_movetext_section;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterMovetext_section(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitMovetext_section(this);
  }
}

class Element_sequenceContext extends ParserRuleContext {
  List<ElementContext> elements() => getRuleContexts<ElementContext>();
  ElementContext? element(int i) => getRuleContext<ElementContext>(i);
  List<Recursive_variationContext> recursive_variations() => getRuleContexts<Recursive_variationContext>();
  Recursive_variationContext? recursive_variation(int i) => getRuleContext<Recursive_variationContext>(i);
  Element_sequenceContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_element_sequence;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterElement_sequence(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitElement_sequence(this);
  }
}

class ElementContext extends ParserRuleContext {
  Full_move_number_indicationContext? full_move_number_indication() => getRuleContext<Full_move_number_indicationContext>(0);
  Black_move_number_indicationContext? black_move_number_indication() => getRuleContext<Black_move_number_indicationContext>(0);
  San_moveContext? san_move() => getRuleContext<San_moveContext>(0);
  Brace_commentContext? brace_comment() => getRuleContext<Brace_commentContext>(0);
  TerminalNode? NUMERIC_ANNOTATION_GLYPH() => getToken(PGNParser.TOKEN_NUMERIC_ANNOTATION_GLYPH, 0);
  ElementContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_element;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterElement(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitElement(this);
  }
}

class Full_move_number_indicationContext extends ParserRuleContext {
  TerminalNode? INTEGER() => getToken(PGNParser.TOKEN_INTEGER, 0);
  TerminalNode? PERIOD() => getToken(PGNParser.TOKEN_PERIOD, 0);
  Full_move_number_indicationContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_full_move_number_indication;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterFull_move_number_indication(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitFull_move_number_indication(this);
  }
}

class Black_move_number_indicationContext extends ParserRuleContext {
  TerminalNode? INTEGER() => getToken(PGNParser.TOKEN_INTEGER, 0);
  List<TerminalNode> PERIODs() => getTokens(PGNParser.TOKEN_PERIOD);
  TerminalNode? PERIOD(int i) => getToken(PGNParser.TOKEN_PERIOD, i);
  Black_move_number_indicationContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_black_move_number_indication;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterBlack_move_number_indication(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitBlack_move_number_indication(this);
  }
}

class San_moveContext extends ParserRuleContext {
  TerminalNode? SYMBOL() => getToken(PGNParser.TOKEN_SYMBOL, 0);
  San_moveContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_san_move;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterSan_move(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitSan_move(this);
  }
}

class Recursive_variationContext extends ParserRuleContext {
  TerminalNode? LEFT_PARENTHESIS() => getToken(PGNParser.TOKEN_LEFT_PARENTHESIS, 0);
  Element_sequenceContext? element_sequence() => getRuleContext<Element_sequenceContext>(0);
  TerminalNode? RIGHT_PARENTHESIS() => getToken(PGNParser.TOKEN_RIGHT_PARENTHESIS, 0);
  Recursive_variationContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_recursive_variation;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterRecursive_variation(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitRecursive_variation(this);
  }
}

class Game_terminationContext extends ParserRuleContext {
  TerminalNode? WHITE_WINS() => getToken(PGNParser.TOKEN_WHITE_WINS, 0);
  TerminalNode? BLACK_WINS() => getToken(PGNParser.TOKEN_BLACK_WINS, 0);
  TerminalNode? DRAWN_GAME() => getToken(PGNParser.TOKEN_DRAWN_GAME, 0);
  TerminalNode? ASTERISK() => getToken(PGNParser.TOKEN_ASTERISK, 0);
  Game_terminationContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_game_termination;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterGame_termination(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitGame_termination(this);
  }
}

class Brace_commentContext extends ParserRuleContext {
  TerminalNode? BRACE_COMMENT() => getToken(PGNParser.TOKEN_BRACE_COMMENT, 0);
  Brace_commentContext([ParserRuleContext? parent, int? invokingState]) : super(parent, invokingState);
  @override
  int get ruleIndex => RULE_brace_comment;
  @override
  void enterRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.enterBrace_comment(this);
  }
  @override
  void exitRule(ParseTreeListener listener) {
    if (listener is PGNListener) listener.exitBrace_comment(this);
  }
}

