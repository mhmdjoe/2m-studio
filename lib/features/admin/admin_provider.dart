import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  if (Firebase.apps.isEmpty) return Stream.value(null);
  return FirebaseAuth.instance.authStateChanges();
});

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AsyncValue<void>>((ref) {
  return AdminNotifier();
});

class AdminNotifier extends StateNotifier<AsyncValue<void>> {
  AdminNotifier() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), 
        password: password.trim()
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      String errorMessage = e.toString();
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? 'Auth error';
      }
      // Added [V2] prefix to verify the new version is live
      state = AsyncValue.error('[V2] $errorMessage', st);
    }
  }

  Future<void> logout() async {
    if (Firebase.apps.isNotEmpty) {
      await FirebaseAuth.instance.signOut();
    }
  }
}

// Helper to check if logged in
final isAdminProvider = Provider<bool>((ref) {
  if (Firebase.apps.isEmpty) return false;
  final user = ref.watch(authStateProvider).value;
  return user != null;
});
