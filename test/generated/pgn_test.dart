import 'package:antlr4/antlr4.dart';
import 'package:chess_pgn_parser/src/generated/PGNParser.dart';
import 'package:chess_pgn_parser/src/generated/PGNLexer.dart';
import 'package:test/test.dart';

class TreeShapeListener implements ParseTreeListener {
  @override
  void enterEveryRule(ParserRuleContext ctx) {
    print(ctx.text);
  }

  @override
  void exitEveryRule(ParserRuleContext node) {}

  @override
  void visitErrorNode(ErrorNode node) {}

  @override
  void visitTerminal(TerminalNode node) {}
}

Future<void> main() async {
  test('PGNLexer.checkVersion()', () {
    PGNLexer.checkVersion();
  });
  test('PGNParser.checkVersion()', () {
    PGNParser.checkVersion();
  });
  test('Parse advanced.pgn', () async {
    final input = await InputStream.fromPath('test/resources/pgn/advanced.pgn');
    final lexer = PGNLexer(input);
    final tokens = CommonTokenStream(lexer);
    final parser = PGNParser(tokens);
    parser.addErrorListener(DiagnosticErrorListener());
    parser.buildParseTree = true;
    final tree = parser.pgn_database();
    ParseTreeWalker.DEFAULT.walk(TreeShapeListener(), tree);
  });
}
