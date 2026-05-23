import 'theme.dart';

/// Ports `STR` + `L()` from primitives.jsx.
class L {
  static final _entries = <String, Map<AppLang, String>>{
    'app_name': {AppLang.id: 'Glow', AppLang.en: 'Glow'},
    'app_tagline': {AppLang.id: 'AI Photo Editor', AppLang.en: 'AI Photo Editor'},
    'cta_enhance': {AppLang.id: 'Enhance Otomatis', AppLang.en: 'Auto Enhance'},
    'cta_continue': {AppLang.id: 'Lanjut', AppLang.en: 'Continue'},
    'cta_get_started': {AppLang.id: 'Mulai gratis', AppLang.en: 'Get started free'},
    'cta_skip': {AppLang.id: 'Lewati', AppLang.en: 'Skip'},
    'cta_export': {AppLang.id: 'Export', AppLang.en: 'Export'},
    'cta_save': {AppLang.id: 'Simpan', AppLang.en: 'Save'},
    'cta_done': {AppLang.id: 'Selesai', AppLang.en: 'Done'},
    'cta_cancel': {AppLang.id: 'Batal', AppLang.en: 'Cancel'},
    'cta_share': {AppLang.id: 'Bagikan', AppLang.en: 'Share'},
    'cta_view_all': {AppLang.id: 'Lihat semua', AppLang.en: 'View all'},
    'cta_unlock': {AppLang.id: 'Unlock Pro', AppLang.en: 'Unlock Pro'},
    'cta_accept_brief': {AppLang.id: 'Terima brief', AppLang.en: 'Accept brief'},
    'cta_open_editor': {AppLang.id: 'Buka editor', AppLang.en: 'Open editor'},
    'cta_try_template': {AppLang.id: 'Coba template', AppLang.en: 'Try template'},
    'tab_home': {AppLang.id: 'Beranda', AppLang.en: 'Home'},
    'tab_studio': {AppLang.id: 'Studio', AppLang.en: 'Studio'},
    'tab_briefs': {AppLang.id: 'Brief', AppLang.en: 'Briefs'},
    'tab_library': {AppLang.id: 'Library', AppLang.en: 'Library'},
    'tab_profile': {AppLang.id: 'Profil', AppLang.en: 'Profile'},
    'greeting': {AppLang.id: 'Halo,', AppLang.en: 'Hey,'},
    'ai_processing': {AppLang.id: 'AI lagi proses…', AppLang.en: 'AI is working…'},
    'before': {AppLang.id: 'Sebelum', AppLang.en: 'Before'},
    'after': {AppLang.id: 'Setelah', AppLang.en: 'After'},
  };

  static String t(String key, AppLang lang) {
    final entry = _entries[key];
    if (entry == null) return key;
    return entry[lang] ?? entry[AppLang.id] ?? key;
  }
}
