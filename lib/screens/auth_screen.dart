import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../core/theme.dart';
import '../services/auth_service.dart';
import '../widgets/glow_btn.dart';
import '../widgets/glow_icon.dart';
import '../widgets/primitives.dart';

/// Sign-in / sign-up screen. Toggles between the two modes via the bottom link.
/// On successful signIn, [AuthGate] rebuilds and shows the shell.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum _Mode { signIn, signUp }

class _AuthScreenState extends State<AuthScreen> {
  _Mode _mode = _Mode.signIn;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _handle = TextEditingController();
  bool _busy = false;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _fullName.dispose();
    _handle.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
      _info = null;
    });
    try {
      if (_mode == _Mode.signIn) {
        await AuthService.signInWithPassword(
          email: _email.text.trim(),
          password: _password.text,
        );
      } else {
        final res = await AuthService.signUp(
          email: _email.text.trim(),
          password: _password.text,
          fullName: _fullName.text.trim().isEmpty
              ? _email.text.trim().split('@').first
              : _fullName.text.trim(),
          handle: _handle.text.trim().isEmpty
              ? _email.text.trim().split('@').first
              : _handle.text.trim(),
        );
        if (res?.session == null) {
          setState(() {
            _info =
                'Cek email kamu untuk konfirmasi link sign-up. Atau matikan "Confirm email" di Supabase Auth settings supaya langsung masuk.';
          });
        }
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    final isSignUp = _mode == _Mode.signUp;
    return Scaffold(
      backgroundColor: t.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const GlowLogo(size: 40, withText: true),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 36),
                Text(
                  isSignUp ? 'Bikin akun Glow' : 'Masuk ke Glow',
                  style: GoogleFonts.inter(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: t.text,
                    letterSpacing: -1,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isSignUp
                      ? 'Daftar sekali, semua brief + project kamu kebawa di semua device.'
                      : 'Lanjut edit foto endorse-an kamu.',
                  style:
                      GoogleFonts.inter(fontSize: 14, color: t.muted, height: 1.5),
                ),
                const SizedBox(height: 28),
                if (isSignUp) ...[
                  _Field(
                    controller: _fullName,
                    hint: 'Nama lengkap',
                    icon: 'user',
                  ),
                  const SizedBox(height: 10),
                  _Field(
                    controller: _handle,
                    hint: 'Handle (mis. andin.id)',
                    icon: 'sparkle',
                  ),
                  const SizedBox(height: 10),
                ],
                _Field(
                  controller: _email,
                  hint: 'Email',
                  icon: 'chat',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                _Field(
                  controller: _password,
                  hint: 'Password',
                  icon: 'lock',
                  obscure: true,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  _Banner(text: _error!, tone: t.danger),
                ],
                if (_info != null) ...[
                  const SizedBox(height: 14),
                  _Banner(text: _info!, tone: t.ai),
                ],
                const SizedBox(height: 20),
                GlowBtn(
                  variant: BtnVariant.glow,
                  size: BtnSize.lg,
                  block: true,
                  onTap: _busy ? null : _submit,
                  child: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isSignUp ? 'Daftar' : 'Masuk'),
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: _busy
                        ? null
                        : () => setState(() {
                              _mode = isSignUp ? _Mode.signIn : _Mode.signUp;
                              _error = null;
                              _info = null;
                            }),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Text.rich(
                        TextSpan(
                          style: GoogleFonts.inter(
                              fontSize: 13, color: t.muted),
                          children: [
                            TextSpan(
                              text: isSignUp
                                  ? 'Udah punya akun? '
                                  : 'Belum punya akun? ',
                            ),
                            TextSpan(
                              text: isSignUp ? 'Masuk' : 'Daftar gratis',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: t.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String icon;
  final bool obscure;
  final TextInputType? keyboardType;
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final t = GlowTheme.of(context).palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 50,
      decoration: BoxDecoration(
        color: t.surface,
        border: Border.all(color: t.line),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GlowIcon(icon, size: 16, color: t.muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(fontSize: 14, color: t.text),
              cursorColor: t.accent,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    GoogleFonts.inter(fontSize: 14, color: t.muted),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final String text;
  final Color tone;
  const _Banner({required this.text, required this.tone});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.08),
        border: Border.all(color: tone.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: tone,
          height: 1.4,
        ),
      ),
    );
  }
}
