import 'package:chess/chess.dart';
import 'package:logging/logging.dart';

final _logger = Logger('tree');

class AnnotatedMove extends Move {
  // Let's cache the moveNumber and the SAN notation for better performance
  final int moveNumber;
  final String san;

  AnnotatedMove(
    super.color,
    super.from,
    super.to,
    super.flags,
    super.piece,
    super.captured,
    super.promotion,
    this.moveNumber,
    this.san,
  );

  AnnotatedMove.fromMove(Move move, int moveNumber, String san)
      : this(
          move.color,
          move.from,
          move.to,
          move.flags,
          move.piece,
          move.captured,
          move.promotion,
          moveNumber,
          san,
        );

  @override
  String toString() => san;
}

class GameWithVariations {
  final GameNode rootNode;

  GameWithVariations(this.rootNode);

  /// Traverse the tree in DFS order.
  void traverse(void Function(Chess board, GameNode node) callback) {
    _logger.fine('Starting traverse()');

    final board = Chess();

    // A stack data structure used by the DFS algorithm.
    //
    // It contains:
    //   1. GameNode objects, whose meaning is to step one level deeper in the
    //      tree in the corresponding direction
    //   2. nulls, which encode to step one level back in the tree
    //
    // The last element of the stack will be the next one being visited, that's
    // why elements are added in reverse order.
    List<GameNode?> stack = [];
    void addToStack(List<GameNode> children) {
      final addToStack = children
          .expand((e) => [
                e, // step deeper
                null, // step back
              ])
          .toList()
          .reversed;
      _logger.finest('Adding to stack: $addToStack');
      stack.addAll(addToStack);
    }

    addToStack([rootNode]);
    while (stack.isNotEmpty) {
      GameNode? node = stack.removeLast();
      _logger.finest('Popping ${node?.move}');
      if (node == null) {
        board.undo_move();
      } else {
        board.move(node.move);
        callback(board, node);
        addToStack(node.children);
      }
      _logger.finest('Move number: ${board.move_number}');
    }

    assert(board.move_number == 1,
        'We should arrive back to the start after performing the DFS');
    _logger.fine('Leaving traverse()');
  }

  @override
  String toString() {
    String formatMove(Color color, int moveNumber, String san) {
      Color lastMoveColor = color == Color.WHITE ? Color.BLACK : Color.WHITE;
      if (lastMoveColor == Color.BLACK) {
        // The moveNumber is increased before black in the chess lib. It is
        // probably a bug.
        --moveNumber;
      }
      final dots = lastMoveColor == Color.WHITE ? '.' : '...';
      final halfMoveNumber =
          (moveNumber - 1) * 2 + (lastMoveColor == Color.BLACK ? 1 : 0);
      return '${'  ' * (halfMoveNumber)}$moveNumber$dots $san';
    }

    final buffer = StringBuffer();
    buffer.write('GameWithVariations(\n');
    traverse((board, node) {
      if (node.rootNode) return;

      buffer.write(
          '  ${formatMove(board.turn, board.move_number, node.move!.san)}\n');
    });
    buffer.write(')');
    return buffer.toString();
  }

  /// Fixes the [GameNode] objects, which were constructed with
  /// [GameNode.rootNodeWithLateParentInit] or [GameNode.withLateParentInit]
  void fixParentsRecursively() {
    final List<GameNode> stack = [];
    stack.addAll([rootNode]);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      node.children.forEach((child) {
        child._parent = node;
        stack.add(child);
      });
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is! GameWithVariations) return false;
    return toString() == (other).toString();
  }

  @override
  int get hashCode => toString().hashCode;
}

class GameNode {
  /// The corresponding [AnnotatedMove].
  ///
  /// Initialized for all [GameNode], except for the root node (see
  /// [rootNode]).
  final AnnotatedMove? move;
  final List<GameNode> children;
  GameNode? get parent => _parent;
  GameNode? _parent;

  bool get rootNode => _parent == null;

  /// Constructor for the root node, which delays the initialization of
  /// [children].
  ///
  /// {@template game_node_late_children_init}
  /// To handle the circular dependency between parents and their children, add
  /// the children later to the [children] list.
  /// {@endtemplate}
  GameNode.rootNodeWithLateChildrenInit()
      : _parent = null,
        children = [],
        move = null;

  /// Constructor, which sets [parent] right away, but delays the initialization
  /// of [children].
  ///
  /// {@macro game_node_late_children_init}
  GameNode.withLateChildrenInit(AnnotatedMove move, GameNode parent)
      :
        // ignore: prefer_initializing_formals
        move = move,
        _parent = parent,
        children = [];

  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent].
  ///
  /// {@template game_node_late_parent_init}
  /// You can set [parent] later by calling
  /// [GameWithVariations.fixParentsRecursively] on the corresponding
  /// [GameWithVariations] object.
  /// {@endtemplate}
  GameNode.rootNodeWithLateParentInit(this.children)
      : move = null,
        _parent = null;

  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent].
  ///
  /// {@macro game_node_late_parent_init}
  GameNode.withLateParentInit(AnnotatedMove move, this.children)
      :
        // ignore: prefer_initializing_formals
        move = move,
        _parent = null;

  @override
  String toString() => 'GameNode(move: ${move?.san})';
}
