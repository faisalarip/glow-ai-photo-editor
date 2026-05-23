import 'package:supabase_flutter/supabase_flutter.dart';

import 'env.dart';
import 'supabase_client.dart';

/// Thin wrapper around Supabase auth. When [Env.isConfigured] is false, every
/// method returns null / no-ops so the app can still render the prototype.
class AuthService {
  static User? get currentUser =>
      Env.isConfigured ? SupabaseInit.client.auth.currentUser : null;

  static Stream<AuthState>? get onAuthStateChange =>
      Env.isConfigured ? SupabaseInit.client.auth.onAuthStateChange : null;

  static Future<AuthResponse?> signInWithPassword({
    required String email,
    required String password,
  }) async {
    if (!Env.isConfigured) return null;
    return SupabaseInit.client.auth
        .signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String handle,
  }) async {
    if (!Env.isConfigured) return null;
    return SupabaseInit.client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName, 'handle': handle},
    );
  }

  static Future<void> signOut() async {
    if (!Env.isConfigured) return;
    await SupabaseInit.client.auth.signOut();
  }
}
