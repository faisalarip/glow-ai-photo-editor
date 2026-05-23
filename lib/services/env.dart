/// Reads SUPABASE_URL + SUPABASE_ANON_KEY from --dart-define. When either is
/// missing, [isConfigured] returns false and repositories fall back to the
/// static demo data so the prototype still runs offline.
class Env {
  static const supabaseUrl =
      String.fromEnvironment('SUPABASE_URL', defaultValue: '');
  static const supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
