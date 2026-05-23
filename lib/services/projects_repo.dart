import 'dart:math';

import '../widgets/photo.dart';
import 'env.dart';
import 'models/models.dart';
import 'supabase_client.dart';

class ProjectsRepo {
  /// Inserts a sample project owned by the signed-in user. Used by the Library
  /// "+" button so people can see the full create → list loop without writing
  /// SQL. No-op when offline / not signed in.
  static Future<Project?> createSample() async {
    if (!Env.isConfigured) return null;
    final user = SupabaseInit.client.auth.currentUser;
    if (user == null) return null;

    const samples = [
      ('Aura Serum', 'enhanced', 'skincare'),
      ('Sonder Tee', 'moody', 'fashion'),
      ('Bali Bites Bowl', 'pastel', 'food'),
      ('Lumo Light Setup', 'studio', 'gadget'),
      ('Morning Self', 'night', 'skincare'),
    ];
    final pick = samples[Random().nextInt(samples.length)];
    final res = await SupabaseInit.client
        .from('projects')
        .insert({
          'owner_id': user.id,
          'label': pick.$1,
          'photo_variant': pick.$2,
          'product_kind': pick.$3,
          'layer_count': 1 + Random().nextInt(8),
          'status': ['draft', 'in_edit', 'done'][Random().nextInt(3)],
        })
        .select('*, brands(name)')
        .single();
    return Project.fromJoinedJson(res);
  }

  /// Returns the signed-in user's projects, or mocks when offline.
  static Future<List<Project>> myProjects() async {
    if (!Env.isConfigured) return _mocks();
    final user = SupabaseInit.client.auth.currentUser;
    if (user == null) return _mocks();
    final res = await SupabaseInit.client
        .from('projects')
        .select('*, brands(name)')
        .eq('owner_id', user.id)
        .order('created_at', ascending: false);
    final rows = res as List<dynamic>;
    return rows
        .map((r) => Project.fromJoinedJson(r as Map<String, dynamic>))
        .toList();
  }

  static List<Project> _mocks() {
    final now = DateTime.now();
    DateTime past(int days) => now.subtract(Duration(days: days));
    return [
      Project(
        id: 'p1',
        ownerId: 'mock',
        brandId: 'b1',
        brandName: 'Aura',
        label: 'Aura Serum',
        photoVariant: PhotoVariant.enhanced,
        productKind: ProductKind.skincare,
        layerCount: 5,
        status: 'done',
        createdAt: past(9),
      ),
      Project(
        id: 'p2',
        ownerId: 'mock',
        brandId: 'b2',
        brandName: 'Sonder',
        label: 'Sonder Outfit',
        photoVariant: PhotoVariant.moody,
        productKind: ProductKind.fashion,
        layerCount: 8,
        status: 'draft',
        createdAt: past(11),
      ),
      Project(
        id: 'p3',
        ownerId: 'mock',
        brandId: 'b3',
        brandName: 'Bali Bites',
        label: 'Bali Bites Menu',
        photoVariant: PhotoVariant.pastel,
        productKind: ProductKind.food,
        layerCount: 12,
        status: 'done',
        createdAt: past(13),
      ),
      Project(
        id: 'p4',
        ownerId: 'mock',
        brandId: 'b4',
        brandName: 'Lumo',
        label: 'Lumo Light',
        photoVariant: PhotoVariant.studio,
        productKind: ProductKind.gadget,
        layerCount: 3,
        status: 'in_edit',
        createdAt: past(15),
      ),
      Project(
        id: 'p5',
        ownerId: 'mock',
        brandId: null,
        brandName: null,
        label: 'Morning Self',
        photoVariant: PhotoVariant.night,
        productKind: ProductKind.skincare,
        layerCount: 4,
        status: 'done',
        createdAt: past(17),
      ),
      Project(
        id: 'p6',
        ownerId: 'mock',
        brandId: 'b5',
        brandName: 'Hush',
        label: 'Hush Routine',
        photoVariant: PhotoVariant.pastel,
        productKind: ProductKind.skincare,
        layerCount: 7,
        status: 'done',
        createdAt: past(19),
      ),
    ];
  }
}
