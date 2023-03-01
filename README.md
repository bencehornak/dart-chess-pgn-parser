# Dart Chess PGN parser

Library for parsing [PGN (Portable Game
Notation)](https://en.wikipedia.org/wiki/Portable_Game_Notation) files, based on
the [antlr4](https://github.com/antlr/antlr4) parser.

## ANTLR

The grammar of the PGN file format is credited to Bart Kiers, see the
[`PGN.g4`](https://github.com/antlr/grammars-v4/blob/38c2da77459a1ad99976c96868ef80284959605f/pgn/PGN.g4).

To generate dart files based on the g4 file:

```bash
antlr4 -o lib/src/generated/ -Dlanguage=Dart -Xexact-output-dir antlr4/PGN.g4
```