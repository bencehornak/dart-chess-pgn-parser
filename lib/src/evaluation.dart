abstract class Evaluation {
  final int? analysisDepth;

  const Evaluation({required this.analysisDepth});
}

class PawnEvaluation extends Evaluation {
  final double difference;

  const PawnEvaluation(
      {required this.difference, required super.analysisDepth});

  @override
  String toString() =>
      'PawnEvaluation(analysisDepth: $analysisDepth, difference: $difference)';

  @override
  bool operator ==(dynamic other) =>
      other is PawnEvaluation &&
      analysisDepth == other.analysisDepth &&
      difference == other.difference;

  @override
  int get hashCode => Object.hash(analysisDepth, difference);
}

class MateInNEvaluation extends Evaluation {
  final int n;

  const MateInNEvaluation({required this.n, required super.analysisDepth});

  @override
  String toString() =>
      'MateInNEvaluation(analysisDepth: $analysisDepth, n: $n)';

  @override
  bool operator ==(dynamic other) =>
      other is MateInNEvaluation &&
      analysisDepth == other.analysisDepth &&
      n == other.n;

  @override
  int get hashCode => Object.hash(analysisDepth, n);
}
