import 'package:chess/chess.dart';
import 'package:chess_pgn_parser/src/tree.dart';
import 'package:chess_pgn_parser/src/tree_iterator.dart';

import 'annotated_move.dart';
import 'linear_move_sequence_tree.dart';

T _onlyElement<T>(List<T> list) {
  assert(list.length == 1);
  return list.first;
}

List<String> _emptyStrings = const ['', '-'];
String? _nullIfEmpty(String string) =>
    _emptyStrings.contains(string) ? null : string;

class ChessHalfMoveTree extends Tree<ChessHalfMoveTreeNode> {
  final Map<String, List<String>> tags;

  String? get tagEvent => _nullIfEmpty(_onlyElement(tags['Event']!));
  String? get tagSite => _nullIfEmpty(_onlyElement(tags['Site']!));
  DateTime get tagDate =>
      DateTime.parse(_onlyElement(tags['Date']!).replaceAll('.', '-'));
  String? get tagRound => _nullIfEmpty(_onlyElement(tags['Round']!));
  List<String> get tagWhite => tags['White']!;
  List<String> get tagBlack => tags['Black']!;
  String get tagResult => _onlyElement(tags['Result']!);

  ChessHalfMoveTree(
      {required ChessHalfMoveTreeNode rootNode, required this.tags})
      : super(rootNode);

  /// Traverse the tree in DFS order.
  void traverse(
      void Function(Chess board, ChessHalfMoveTreeNode node) callback) {
    final iterator = ChessHalfMoveDepthFirstSearchTreeIterator(this);
    while (iterator.moveNext()) {
      final element = iterator.current;
      callback(element.board, element.node);
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('ChessHalfMoveTree(\n');

    // Tags
    buffer.write('  tags:\n');
    tags.forEach(
        (key, value) => buffer.write('    $key: ${value.join(', ')}\n'));

    // Moves
    buffer.write('  moves:\n');
    // Convert to LinearMoveSequenceTree for a denser notation
    final sequenceTree = LinearMoveSequenceTree.fromGame(this);
    sequenceTree.traverse((node) {
      if (node.rootNode) return;
      buffer.write('  ' * (node.depth + 1));

      node.sequence.asMap().forEach((index, sequenceItem) {
        bool firstOneInSequence = index == 0;

        if (!firstOneInSequence) buffer.write(' ');

        final move = sequenceItem.node.move!;
        buffer.write(move.toHumanReadable(
            showBlackMoveNumberIndicator: firstOneInSequence));

        if (move.comment != null) buffer.write(" {${move.comment}}");
      });
      buffer.write('\n');
    });

    buffer.write(')');
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! ChessHalfMoveTree) return false;
    return toString() == (other).toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class ChessHalfMoveTreeNode extends TreeNode<ChessHalfMoveTreeNode> {
  /// The corresponding [AnnotatedMove].
  ///
  /// Initialized for all [ChessHalfMoveTreeNode], except for the root node (see
  /// [rootNode]).
  final AnnotatedMove? move;

  /// Variation depth.
  ///
  /// {@template variation_depth}
  /// The value 0 represents the main-line, 1 means a side-line, 2 means a
  /// side-line of a side-line and so on.
  /// {@endtemplate}
  final int variationDepth;

  /// {@macro tree_node_root_node_with_late_children_init}
  ChessHalfMoveTreeNode.rootNodeWithLateChildrenInit()
      : move = null,
        variationDepth = 0,
        super.rootNodeWithLateChildrenInit();

  /// {@macro tree_node_with_late_children_init}
  ChessHalfMoveTreeNode.withLateChildrenInit(
      {required AnnotatedMove move,
      required ChessHalfMoveTreeNode parent,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        super.withLateChildrenInit(parent: parent);

  /// {@macro tree_node_root_node_with_late_parent_init}
  ChessHalfMoveTreeNode.rootNodeWithLateParentInit(
      {required List<ChessHalfMoveTreeNode> children})
      : move = null,
        variationDepth = 0,
        super.rootNodeWithLateParentInit(children: children);

  /// {@macro tree_node_with_late_parent_init}
  ChessHalfMoveTreeNode.withLateParentInit(
      {required AnnotatedMove move,
      required List<ChessHalfMoveTreeNode> children,
      required this.variationDepth})
      :
        // ignore: prefer_initializing_formals
        move = move,
        super.withLateParentInit(children: children);

  @override
  String toString() => 'ChessHalfMoveTreeNode(move: ${move?.san})';
}

class ChessHalfMoveDepthFirstSearchTreeIterator
    extends DepthFirstSearchTreeIterator<ChessHalfMoveTree,
        ChessHalfMoveTreeNode, ChessHalfMoveTreeIteratorElement> {
  final _board = Chess();

  ChessHalfMoveDepthFirstSearchTreeIterator(super.tree);

  @override
  ChessHalfMoveTreeIteratorElement transformNode(ChessHalfMoveTreeNode node) =>
      ChessHalfMoveTreeIteratorElement(node: node, board: _board);

  @override
  void onStepIn(ChessHalfMoveTreeNode node) {
    _board.move(node.move);
  }

  @override
  void onStepOut() {
    _board.undo_move();
  }

  @override
  void onTraversalFinished() {
    assert(_board.move_number == 1,
        'We should arrive back to the start after performing the DFS');
  }
}

class ChessHalfMoveTreeIteratorElement {
  final ChessHalfMoveTreeNode node;
  final Chess board;

  const ChessHalfMoveTreeIteratorElement(
      {required this.node, required this.board});
}
