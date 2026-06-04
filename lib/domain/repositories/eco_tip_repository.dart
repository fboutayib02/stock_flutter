import '../entities/eco_tip.dart';

abstract class EcoTipRepository {
  Future<EcoTip> fetchTip();
}
