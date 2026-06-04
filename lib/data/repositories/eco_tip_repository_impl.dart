import '../../domain/entities/eco_tip.dart';
import '../../domain/repositories/eco_tip_repository.dart';
import '../datasources/remote/eco_tip_remote_data_source.dart';

class EcoTipRepositoryImpl implements EcoTipRepository {
  EcoTipRepositoryImpl(this._remote);

  final EcoTipRemoteDataSource _remote;

  @override
  Future<EcoTip> fetchTip() async {
    try {
      final message = await _remote.fetchAdvice();
      return EcoTip(message: message);
    } catch (_) {
      return const EcoTip(
        message:
            'Roulez à vitesse stable et vérifiez la pression des pneus pour '
            'réduire la consommation.',
      );
    }
  }
}
