import 'env.dart';
import 'models/models.dart';
import 'supabase_client.dart';

class ProfilesRepo {
  /// Returns the signed-in user's profile, or a mock when offline.
  static Future<Profile> currentProfile() async {
    if (!Env.isConfigured) return _mock();
    final user = SupabaseInit.client.auth.currentUser;
    if (user == null) return _mock();
    final res = await SupabaseInit.client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();
    if (res == null) return _mock();
    return Profile.fromJson(res);
  }

  static Profile _mock() => Profile(
        id: 'mock-andin',
        handle: 'andin.id',
        fullName: 'Andin Pradipta',
        avatarUrl: null,
        bio: 'Beauty · Lifestyle',
        followers: 124000,
        tier: 'pro',
      );
}
