// Generated from antlr4/PGN.g4 by ANTLR 4.11.1
// ignore_for_file: unused_import, unused_local_variable, prefer_single_quotes
import 'package:antlr4/antlr4.dart';


class PGNLexer extends Lexer {
  static final checkVersion = () => RuntimeMetaData.checkVersion('4.11.1', RuntimeMetaData.VERSION);

  static final List<DFA> _decisionToDFA = List.generate(
        _ATN.numberOfDecisions, (i) => DFA(_ATN.getDecisionState(i), i));
  static final PredictionContextCache _sharedContextCache = PredictionContextCache();
  static const int
    TOKEN_WHITE_WINS = 1, TOKEN_BLACK_WINS = 2, TOKEN_DRAWN_GAME = 3, TOKEN_REST_OF_LINE_COMMENT = 4, 
    TOKEN_BRACE_COMMENT = 5, TOKEN_ESCAPE = 6, TOKEN_SPACES = 7, TOKEN_STRING = 8, 
    TOKEN_INTEGER = 9, TOKEN_PERIOD = 10, TOKEN_ASTERISK = 11, TOKEN_LEFT_BRACKET = 12, 
    TOKEN_RIGHT_BRACKET = 13, TOKEN_LEFT_PARENTHESIS = 14, TOKEN_RIGHT_PARENTHESIS = 15, 
    TOKEN_LEFT_ANGLE_BRACKET = 16, TOKEN_RIGHT_ANGLE_BRACKET = 17, TOKEN_NUMERIC_ANNOTATION_GLYPH = 18, 
    TOKEN_SYMBOL = 19, TOKEN_SUFFIX_ANNOTATION = 20, TOKEN_UNEXPECTED_CHAR = 21;
  @override
  final List<String> channelNames = [
    'DEFAULT_TOKEN_CHANNEL', 'HIDDEN'
  ];

  @override
  final List<String> modeNames = [
    'DEFAULT_MODE'
  ];

  @override
  final List<String> ruleNames = [
    'WHITE_WINS', 'BLACK_WINS', 'DRAWN_GAME', 'REST_OF_LINE_COMMENT', 'BRACE_COMMENT', 
    'ESCAPE', 'SPACES', 'STRING', 'INTEGER', 'PERIOD', 'ASTERISK', 'LEFT_BRACKET', 
    'RIGHT_BRACKET', 'LEFT_PARENTHESIS', 'RIGHT_PARENTHESIS', 'LEFT_ANGLE_BRACKET', 
    'RIGHT_ANGLE_BRACKET', 'NUMERIC_ANNOTATION_GLYPH', 'SYMBOL', 'SUFFIX_ANNOTATION', 
    'UNEXPECTED_CHAR'
  ];

  static final List<String?> _LITERAL_NAMES = [
      null, "'1-0'", "'0-1'", "'1/2-1/2'", null, null, null, null, null, 
      null, "'.'", "'*'", "'['", "']'", "'('", "')'", "'<'", "'>'"
  ];
  static final List<String?> _SYMBOLIC_NAMES = [
      null, "WHITE_WINS", "BLACK_WINS", "DRAWN_GAME", "REST_OF_LINE_COMMENT", 
      "BRACE_COMMENT", "ESCAPE", "SPACES", "STRING", "INTEGER", "PERIOD", 
      "ASTERISK", "LEFT_BRACKET", "RIGHT_BRACKET", "LEFT_PARENTHESIS", "RIGHT_PARENTHESIS", 
      "LEFT_ANGLE_BRACKET", "RIGHT_ANGLE_BRACKET", "NUMERIC_ANNOTATION_GLYPH", 
      "SYMBOL", "SUFFIX_ANNOTATION", "UNEXPECTED_CHAR"
  ];
  static final Vocabulary VOCABULARY = VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

  @override
  Vocabulary get vocabulary {
    return VOCABULARY;
  }


  PGNLexer(CharStream input) : super(input) {
    interpreter = LexerATNSimulator(_ATN, _decisionToDFA, _sharedContextCache, recog: this);
  }

  @override
  List<int> get serializedATN => _serializedATN;

  @override
  String get grammarFileName => 'PGN.g4';

  @override
  ATN getATN() { return _ATN; }

  bool sempred(RuleContext? _localctx, int ruleIndex, int predIndex) {
    switch (ruleIndex) {
    case 5:
      return _ESCAPE_sempred(_localctx, predIndex);
    }
    return true;
  }
  bool _ESCAPE_sempred(dynamic _localctx, int predIndex) {
    switch (predIndex) {
      case 0: return charPositionInLine == 0;
    }
    return true;
  }

  static const List<int> _serializedATN = [
      4,0,21,149,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,2,
      6,7,6,2,7,7,7,2,8,7,8,2,9,7,9,2,10,7,10,2,11,7,11,2,12,7,12,2,13,7,
      13,2,14,7,14,2,15,7,15,2,16,7,16,2,17,7,17,2,18,7,18,2,19,7,19,2,20,
      7,20,1,0,1,0,1,0,1,0,1,1,1,1,1,1,1,1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,
      2,1,3,1,3,5,3,62,8,3,10,3,12,3,65,9,3,1,3,1,3,1,4,1,4,5,4,71,8,4,10,
      4,12,4,74,9,4,1,4,1,4,1,4,1,4,1,5,1,5,1,5,5,5,83,8,5,10,5,12,5,86,
      9,5,1,5,1,5,1,6,4,6,91,8,6,11,6,12,6,92,1,6,1,6,1,7,1,7,1,7,1,7,1,
      7,1,7,5,7,103,8,7,10,7,12,7,106,9,7,1,7,1,7,1,8,4,8,111,8,8,11,8,12,
      8,112,1,9,1,9,1,10,1,10,1,11,1,11,1,12,1,12,1,13,1,13,1,14,1,14,1,
      15,1,15,1,16,1,16,1,17,1,17,4,17,133,8,17,11,17,12,17,134,1,18,1,18,
      5,18,139,8,18,10,18,12,18,142,9,18,1,19,1,19,3,19,146,8,19,1,20,1,
      20,0,0,21,1,1,3,2,5,3,7,4,9,5,11,6,13,7,15,8,17,9,19,10,21,11,23,12,
      25,13,27,14,29,15,31,16,33,17,35,18,37,19,39,20,41,21,1,0,8,2,0,10,
      10,13,13,1,0,125,125,3,0,9,10,13,13,32,32,2,0,34,34,92,92,1,0,48,57,
      3,0,48,57,65,90,97,122,8,0,35,35,43,43,45,45,48,58,61,61,65,90,95,
      95,97,122,2,0,33,33,63,63,159,0,1,1,0,0,0,0,3,1,0,0,0,0,5,1,0,0,0,
      0,7,1,0,0,0,0,9,1,0,0,0,0,11,1,0,0,0,0,13,1,0,0,0,0,15,1,0,0,0,0,17,
      1,0,0,0,0,19,1,0,0,0,0,21,1,0,0,0,0,23,1,0,0,0,0,25,1,0,0,0,0,27,1,
      0,0,0,0,29,1,0,0,0,0,31,1,0,0,0,0,33,1,0,0,0,0,35,1,0,0,0,0,37,1,0,
      0,0,0,39,1,0,0,0,0,41,1,0,0,0,1,43,1,0,0,0,3,47,1,0,0,0,5,51,1,0,0,
      0,7,59,1,0,0,0,9,68,1,0,0,0,11,79,1,0,0,0,13,90,1,0,0,0,15,96,1,0,
      0,0,17,110,1,0,0,0,19,114,1,0,0,0,21,116,1,0,0,0,23,118,1,0,0,0,25,
      120,1,0,0,0,27,122,1,0,0,0,29,124,1,0,0,0,31,126,1,0,0,0,33,128,1,
      0,0,0,35,130,1,0,0,0,37,136,1,0,0,0,39,143,1,0,0,0,41,147,1,0,0,0,
      43,44,5,49,0,0,44,45,5,45,0,0,45,46,5,48,0,0,46,2,1,0,0,0,47,48,5,
      48,0,0,48,49,5,45,0,0,49,50,5,49,0,0,50,4,1,0,0,0,51,52,5,49,0,0,52,
      53,5,47,0,0,53,54,5,50,0,0,54,55,5,45,0,0,55,56,5,49,0,0,56,57,5,47,
      0,0,57,58,5,50,0,0,58,6,1,0,0,0,59,63,5,59,0,0,60,62,8,0,0,0,61,60,
      1,0,0,0,62,65,1,0,0,0,63,61,1,0,0,0,63,64,1,0,0,0,64,66,1,0,0,0,65,
      63,1,0,0,0,66,67,6,3,0,0,67,8,1,0,0,0,68,72,5,123,0,0,69,71,8,1,0,
      0,70,69,1,0,0,0,71,74,1,0,0,0,72,70,1,0,0,0,72,73,1,0,0,0,73,75,1,
      0,0,0,74,72,1,0,0,0,75,76,5,125,0,0,76,77,1,0,0,0,77,78,6,4,0,0,78,
      10,1,0,0,0,79,80,4,5,0,0,80,84,5,37,0,0,81,83,8,0,0,0,82,81,1,0,0,
      0,83,86,1,0,0,0,84,82,1,0,0,0,84,85,1,0,0,0,85,87,1,0,0,0,86,84,1,
      0,0,0,87,88,6,5,0,0,88,12,1,0,0,0,89,91,7,2,0,0,90,89,1,0,0,0,91,92,
      1,0,0,0,92,90,1,0,0,0,92,93,1,0,0,0,93,94,1,0,0,0,94,95,6,6,0,0,95,
      14,1,0,0,0,96,104,5,34,0,0,97,98,5,92,0,0,98,103,5,92,0,0,99,100,5,
      92,0,0,100,103,5,34,0,0,101,103,8,3,0,0,102,97,1,0,0,0,102,99,1,0,
      0,0,102,101,1,0,0,0,103,106,1,0,0,0,104,102,1,0,0,0,104,105,1,0,0,
      0,105,107,1,0,0,0,106,104,1,0,0,0,107,108,5,34,0,0,108,16,1,0,0,0,
      109,111,7,4,0,0,110,109,1,0,0,0,111,112,1,0,0,0,112,110,1,0,0,0,112,
      113,1,0,0,0,113,18,1,0,0,0,114,115,5,46,0,0,115,20,1,0,0,0,116,117,
      5,42,0,0,117,22,1,0,0,0,118,119,5,91,0,0,119,24,1,0,0,0,120,121,5,
      93,0,0,121,26,1,0,0,0,122,123,5,40,0,0,123,28,1,0,0,0,124,125,5,41,
      0,0,125,30,1,0,0,0,126,127,5,60,0,0,127,32,1,0,0,0,128,129,5,62,0,
      0,129,34,1,0,0,0,130,132,5,36,0,0,131,133,7,4,0,0,132,131,1,0,0,0,
      133,134,1,0,0,0,134,132,1,0,0,0,134,135,1,0,0,0,135,36,1,0,0,0,136,
      140,7,5,0,0,137,139,7,6,0,0,138,137,1,0,0,0,139,142,1,0,0,0,140,138,
      1,0,0,0,140,141,1,0,0,0,141,38,1,0,0,0,142,140,1,0,0,0,143,145,7,7,
      0,0,144,146,7,7,0,0,145,144,1,0,0,0,145,146,1,0,0,0,146,40,1,0,0,0,
      147,148,9,0,0,0,148,42,1,0,0,0,11,0,63,72,84,92,102,104,112,134,140,
      145,1,6,0,0
  ];

  static final ATN _ATN =
      ATNDeserializer().deserialize(_serializedATN);
}