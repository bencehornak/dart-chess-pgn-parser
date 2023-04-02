abstract class Evaluation {
  final int? analysisDepth;

  const Evaluation({required this.analysisDepth});
}

class PawnEvaluation extends Evaluation {
  final double difference;

  const PawnEvaluation(
      {required this.difference, required super.analysisDepth});
}

class MateInNEvaluation extends Evaluation {
  final int n;

  const MateInNEvaluation({required this.n, required super.analysisDepth});
}
