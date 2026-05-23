import '../../widgets/photo.dart';

/// Maps the SQL `photo_variant` enum ↔ Dart [PhotoVariant].
PhotoVariant photoVariantFromString(String? s) => switch (s) {
      'raw' => PhotoVariant.raw,
      'enhanced' => PhotoVariant.enhanced,
      'nobg' => PhotoVariant.nobg,
      'moody' => PhotoVariant.moody,
      'studio' => PhotoVariant.studio,
      'pastel' => PhotoVariant.pastel,
      'night' => PhotoVariant.night,
      _ => PhotoVariant.enhanced,
    };

ProductKind productKindFromString(String? s) => switch (s) {
      'skincare' => ProductKind.skincare,
      'fashion' => ProductKind.fashion,
      'food' => ProductKind.food,
      'gadget' => ProductKind.gadget,
      'none' => ProductKind.none,
      _ => ProductKind.skincare,
    };

class Profile {
  final String id;
  final String handle;
  final String fullName;
  final String? avatarUrl;
  final String? bio;
  final int followers;
  final String tier; // free / pro
  Profile({
    required this.id,
    required this.handle,
    required this.fullName,
    this.avatarUrl,
    this.bio,
    required this.followers,
    required this.tier,
  });

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as String,
        handle: j['handle'] as String,
        fullName: j['full_name'] as String,
        avatarUrl: j['avatar_url'] as String?,
        bio: j['bio'] as String?,
        followers: (j['followers'] as num?)?.toInt() ?? 0,
        tier: j['tier'] as String? ?? 'free',
      );
}

class Brand {
  final String id;
  final String name;
  final String category;
  final String? logoColor;
  Brand({
    required this.id,
    required this.name,
    required this.category,
    this.logoColor,
  });
  factory Brand.fromJson(Map<String, dynamic> j) => Brand(
        id: j['id'] as String,
        name: j['name'] as String,
        category: j['category'] as String,
        logoColor: j['logo_color'] as String?,
      );
}

class Brief {
  final String id;
  final String brandId;
  final String brandName;
  final String brandCategory;
  final String title;
  final String deliverables;
  final String rate;
  final DateTime deadline;
  final PhotoVariant mood;
  final ProductKind productKind;
  final String status; // open / closed / fulfilled
  final bool isNew;

  Brief({
    required this.id,
    required this.brandId,
    required this.brandName,
    required this.brandCategory,
    required this.title,
    required this.deliverables,
    required this.rate,
    required this.deadline,
    required this.mood,
    required this.productKind,
    required this.status,
    required this.isNew,
  });

  factory Brief.fromJoinedJson(Map<String, dynamic> j) {
    final brand = j['brands'] as Map<String, dynamic>?;
    final created =
        DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now();
    return Brief(
      id: j['id'] as String,
      brandId: j['brand_id'] as String,
      brandName: brand?['name'] as String? ?? 'Brand',
      brandCategory: brand?['category'] as String? ?? '',
      title: j['title'] as String,
      deliverables: j['deliverables'] as String,
      rate: j['rate'] as String,
      deadline: DateTime.parse(j['deadline'] as String),
      mood: photoVariantFromString(j['mood'] as String?),
      productKind: productKindFromString(j['product_kind'] as String?),
      status: j['status'] as String? ?? 'open',
      isNew: DateTime.now().difference(created).inDays <= 7,
    );
  }
}

class Project {
  final String id;
  final String ownerId;
  final String? brandId;
  final String? brandName;
  final String label;
  final PhotoVariant photoVariant;
  final ProductKind productKind;
  final int layerCount;
  final String status; // draft / in_edit / done
  final DateTime createdAt;

  Project({
    required this.id,
    required this.ownerId,
    this.brandId,
    this.brandName,
    required this.label,
    required this.photoVariant,
    required this.productKind,
    required this.layerCount,
    required this.status,
    required this.createdAt,
  });

  factory Project.fromJoinedJson(Map<String, dynamic> j) {
    final brand = j['brands'] as Map<String, dynamic>?;
    return Project(
      id: j['id'] as String,
      ownerId: j['owner_id'] as String,
      brandId: j['brand_id'] as String?,
      brandName: brand?['name'] as String?,
      label: j['label'] as String,
      photoVariant: photoVariantFromString(j['photo_variant'] as String?),
      productKind: productKindFromString(j['product_kind'] as String?),
      layerCount: (j['layer_count'] as num?)?.toInt() ?? 1,
      status: j['status'] as String? ?? 'draft',
      createdAt:
          DateTime.tryParse(j['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
