abstract class Tree<Node extends TreeNode<Node>> {
  final Node rootNode;

  Tree(this.rootNode);

  /// Fixes the [TreeNode] objects, which were constructed with
  /// [ChessTreeNode.rootNodeWithLateParentInit] or
  /// [ChessTreeNode.withLateParentInit]
  void fixParentsRecursively() {
    final List<Node> stack = [];
    stack.addAll([rootNode]);

    while (stack.isNotEmpty) {
      final node = stack.removeLast();
      node.children.forEach((child) {
        child._parent = node;
        child._depth = node._depth! + 1;
        stack.add(child);
      });
    }
  }
}

abstract class TreeNode<Node> {
  final List<Node> children;
  Node? get parent => _parent;
  Node? _parent;

  /// The depth of the node in the tree.
  ///
  /// The root node's depth is zero, its children's is 1 and so on.
  int get depth => _depth!;
  int? _depth;

  bool get rootNode => parent == null;

  /// {@template tree_node_root_node_with_late_children_init}
  /// Constructor for the root node, which delays the initialization of
  /// [children].
  ///
  /// {@template tree_node_late_children_init}
  /// To handle the circular dependency between parents and their children, add
  /// the children later to the [children] list.
  /// {@endtemplate}
  /// {@endtemplate}
  TreeNode.rootNodeWithLateChildrenInit()
      : _parent = null,
        children = [],
        _depth = 0;

  /// {@template tree_node_with_late_children_init}
  /// Constructor, which sets [parent] right away, but delays the initialization
  /// of [children].
  ///
  /// {@macro tree_node_late_children_init}
  /// {@endtemplate}
  TreeNode.withLateChildrenInit({required Node parent})
      : _parent = parent,
        children = [],
        _depth = (parent as TreeNode)._depth! + 1;

  /// {@template tree_node_root_node_with_late_parent_init}
  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent] (and [depth]).
  ///
  /// {@template tree_node_late_parent_init}
  /// You can set [parent] (and [depth]) later by calling
  /// [Tree.fixParentsRecursively] on the corresponding
  /// [Tree] object.
  /// {@endtemplate}
  /// {@endtemplate}
  TreeNode.rootNodeWithLateParentInit({required this.children})
      : _parent = null,
        _depth = 0;

  /// {@template tree_node_with_late_parent_init}
  /// Constructor, which sets [children] right away, but delays the
  /// initialization of [parent] (and [depth]).
  ///
  /// {@macro tree_node_late_parent_init}
  /// {@endtemplate}
  TreeNode.withLateParentInit({required this.children}) : _parent = null;
}
