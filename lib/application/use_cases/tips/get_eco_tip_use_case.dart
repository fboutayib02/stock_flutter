import '../../../domain/entities/eco_tip.dart';
import '../../../domain/repositories/eco_tip_repository.dart';

class GetEcoTipUseCase {
  const GetEcoTipUseCase(this._repository);

  final EcoTipRepository _repository;

  Future<EcoTip> call() => _repository.fetchTip();
}
