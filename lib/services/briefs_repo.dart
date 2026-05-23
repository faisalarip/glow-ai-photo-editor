import '../widgets/photo.dart';
import 'env.dart';
import 'models/models.dart';
import 'supabase_client.dart';

class BriefsRepo {
  /// Open briefs joined with their brand. Falls back to mocks offline.
  static Future<List<Brief>> openBriefs() async {
    if (!Env.isConfigured) return _mocks();
    final res = await SupabaseInit.client
        .from('briefs')
        .select('*, brands(name, category, logo_color)')
        .eq('status', 'open')
        .order('created_at', ascending: false);
    final rows = res as List<dynamic>;
    return rows
        .map((r) => Brief.fromJoinedJson(r as Map<String, dynamic>))
        .toList();
  }

  /// Mirrors the design's seed list — used when no Supabase project is wired up.
  static List<Brief> _mocks() {
    final now = DateTime.now();
    DateTime due(int days) => now.add(Duration(days: days));
    return [
      Brief(
        id: 'm1',
        brandId: 'b1',
        brandName: 'Aura',
        brandCategory: 'Skincare',
        title: 'Serum endorse · 5 foto + 1 reels',
        deliverables: '5 foto + 1 reels',
        rate: 'Rp 4.5jt + 8% komisi',
        deadline: due(3),
        mood: PhotoVariant.pastel,
        productKind: ProductKind.skincare,
        status: 'open',
        isNew: true,
      ),
      Brief(
        id: 'm2',
        brandId: 'b2',
        brandName: 'Sonder',
        brandCategory: 'Fashion',
        title: 'Summer lookbook · 8 outfit',
        deliverables: '8 outfit',
        rate: 'Rp 8jt fixed',
        deadline: due(7),
        mood: PhotoVariant.night,
        productKind: ProductKind.fashion,
        status: 'open',
        isNew: true,
      ),
      Brief(
        id: 'm3',
        brandId: 'b3',
        brandName: 'Bali Bites',
        brandCategory: 'Food',
        title: 'Menu launch · 1 reels + carousel',
        deliverables: '1 reels + carousel',
        rate: 'Rp 3.2jt + dinner',
        deadline: due(6),
        mood: PhotoVariant.enhanced,
        productKind: ProductKind.food,
        status: 'open',
        isNew: true,
      ),
      Brief(
        id: 'm4',
        brandId: 'b4',
        brandName: 'Lumo',
        brandCategory: 'Tech',
        title: 'Smart light review · 3 foto',
        deliverables: '3 foto',
        rate: 'Rp 2.8jt + free unit',
        deadline: due(11),
        mood: PhotoVariant.moody,
        productKind: ProductKind.gadget,
        status: 'open',
        isNew: false,
      ),
      Brief(
        id: 'm5',
        brandId: 'b5',
        brandName: 'Hush',
        brandCategory: 'Lifestyle',
        title: 'Morning routine · 1 vlog',
        deliverables: '1 vlog',
        rate: 'Rp 5jt',
        deadline: due(15),
        mood: PhotoVariant.studio,
        productKind: ProductKind.skincare,
        status: 'open',
        isNew: false,
      ),
    ];
  }
}
