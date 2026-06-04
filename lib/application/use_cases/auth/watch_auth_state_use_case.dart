import 'package:firebase_auth/firebase_auth.dart';

import '../../../domain/repositories/auth_repository.dart';

class WatchAuthStateUseCase {
  const WatchAuthStateUseCase(this._repository);

  final AuthRepository _repository;

  Stream<User?> call() => _repository.authStateChanges();

  String? currentUserId() => _repository.currentUser?.uid;
}
