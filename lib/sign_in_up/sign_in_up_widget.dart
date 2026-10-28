import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sign_in_up_model.dart';
export 'sign_in_up_model.dart';

/// Sign in / create account. Layout ported from the 21st.dev "Login Card"
/// (hirael login-01): bordered card with a hard offset shadow, header with
/// the brand mark and a serif title, labelled fields, primary button with an
/// arrow, "or continue with" separator, Google button, and a footer link
/// that switches between signing in and creating an account.
class SignInUpWidget extends StatefulWidget {
  const SignInUpWidget({super.key});

  static String routeName = 'SignInUp';
  static String routePath = '/signInUp';

  @override
  State<SignInUpWidget> createState() => _SignInUpWidgetState();
}

class _SignInUpWidgetState extends State<SignInUpWidget>
    with TickerProviderStateMixin {
  late SignInUpModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _signUp = false;
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignInUpModel());
    _model.tabBarController = TabController(vsync: this, length: 2);

    _model.emailAddressTextController ??= TextEditingController();
    _model.emailAddressFocusNode ??= FocusNode();
    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
    _model.emailAddressCreateTextController ??= TextEditingController();
    _model.emailAddressCreateFocusNode ??= FocusNode();
    _model.passwordCreateTextController ??= TextEditingController();
    _model.passwordCreateFocusNode ??= FocusNode();
    _model.passwordConfirmTextController ??= TextEditingController();
    _model.passwordConfirmFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
          ),
          backgroundColor: kFcInk,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _goNext() async {
    if (!mounted) return;
    context.pushNamedAuth(TAYMinorSelectionWidget.routeName, context.mounted);
  }

  Future<void> _submit() async {
    if (_pending) return;
    GoRouter.of(context).prepareAuthEvent();
    setState(() => _pending = true);
    try {
      if (_signUp) {
        if (_model.passwordCreateTextController.text !=
            _model.passwordConfirmTextController.text) {
          _toast("Passwords don't match.");
          return;
        }
        final user = await authManager.createAccountWithEmail(
          context,
          _model.emailAddressCreateTextController.text,
          _model.passwordCreateTextController.text,
        );
        if (user == null) return;
      } else {
        final user = await authManager.signInWithEmail(
          context,
          _model.emailAddressTextController.text,
          _model.passwordTextController.text,
        );
        if (user == null) return;
      }
      await _goNext();
    } finally {
      if (mounted) setState(() => _pending = false);
    }
  }

  Future<void> _google() async {
    GoRouter.of(context).prepareAuthEvent();
    final user = await authManager.signInWithGoogle(context);
    if (user == null) return;
    await _goNext();
  }

  Future<void> _forgot() async {
    final email = _model.emailAddressTextController.text.trim();
    if (email.isEmpty) {
      _toast('Enter your email first, then tap Forgot.');
      return;
    }
    await authManager.resetPassword(email: email, context: context);
  }

  // Entrance used by the 21st card: fade + 16px rise, 500ms, eased out.
  Widget _enter(Widget child, int index) => child
      .animate(delay: (60 * index).ms)
      .fadeIn(duration: 500.ms, curve: const Cubic(0.22, 1, 0.36, 1))
      .moveY(
        begin: 16,
        end: 0,
        duration: 500.ms,
        curve: const Cubic(0.22, 1, 0.36, 1),
      );

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: Stack(
          children: [
            const Positioned.fill(child: _GridBackdrop()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _enter(_card(theme), 0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(FlutterFlowTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.alternate),
        boxShadow: [
          BoxShadow(color: theme.alternate, offset: const Offset(8, 8)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(theme),
          Divider(height: 1, thickness: 1, color: theme.alternate),
          Padding(
            padding: const EdgeInsets.all(24),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(key: ValueKey(_signUp), child: _form(theme)),
            ),
          ),
          Divider(height: 1, thickness: 1, color: theme.alternate),
          _footer(theme),
        ],
      ),
    );
  }

  Widget _header(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      child: Column(
        children: [
          _enter(
            Image.asset(
              'assets/images/fchome 2026 actually heart transparent.png',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            0,
          ),
          const SizedBox(height: 16),
          _enter(
            Text(
              _signUp ? 'Create Account' : 'Welcome Back',
              textAlign: TextAlign.center,
              style: fcHeadline(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
              ),
            ),
            1,
          ),
          const SizedBox(height: 4),
          _enter(
            Text(
              _signUp
                  ? 'Save your journal and track your passes.'
                  : 'Sign in to FCHome to continue.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.secondaryText,
              ),
            ),
            2,
          ),
        ],
      ),
    );
  }

  Widget _form(FlutterFlowTheme theme) {
    final fields = _signUp
        ? [
            _field(
              theme,
              label: 'Email',
              controller: _model.emailAddressCreateTextController!,
              focus: _model.emailAddressCreateFocusNode!,
              hint: 'you@example.com',
              keyboard: TextInputType.emailAddress,
              autofill: AutofillHints.email,
            ),
            _field(
              theme,
              label: 'Password',
              controller: _model.passwordCreateTextController!,
              focus: _model.passwordCreateFocusNode!,
              hint: '••••••••',
              obscure: !_model.passwordCreateVisibility,
              onToggle: () => setState(
                () => _model.passwordCreateVisibility =
                    !_model.passwordCreateVisibility,
              ),
              autofill: AutofillHints.newPassword,
            ),
            _field(
              theme,
              label: 'Confirm Password',
              controller: _model.passwordConfirmTextController!,
              focus: _model.passwordConfirmFocusNode!,
              hint: '••••••••',
              obscure: !_model.passwordConfirmVisibility,
              onToggle: () => setState(
                () => _model.passwordConfirmVisibility =
                    !_model.passwordConfirmVisibility,
              ),
              autofill: AutofillHints.newPassword,
            ),
          ]
        : [
            _field(
              theme,
              label: 'Email',
              controller: _model.emailAddressTextController!,
              focus: _model.emailAddressFocusNode!,
              hint: 'you@example.com',
              keyboard: TextInputType.emailAddress,
              autofill: AutofillHints.email,
            ),
            _field(
              theme,
              label: 'Password',
              controller: _model.passwordTextController!,
              focus: _model.passwordFocusNode!,
              hint: '••••••••',
              obscure: !_model.passwordVisibility,
              onToggle: () => setState(
                () => _model.passwordVisibility = !_model.passwordVisibility,
              ),
              trailingLabel: 'Forgot?',
              onTrailing: _forgot,
              autofill: AutofillHints.password,
            ),
          ];

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final f in fields) ...[f, const SizedBox(height: 20)],
          _primaryButton(theme),
          const SizedBox(height: 20),
          _separator(theme),
          const SizedBox(height: 20),
          _googleButton(theme),
        ],
      ),
    );
  }

  Widget _field(
    FlutterFlowTheme theme, {
    required String label,
    required TextEditingController controller,
    required FocusNode focus,
    required String hint,
    TextInputType? keyboard,
    bool? obscure,
    VoidCallback? onToggle,
    String? trailingLabel,
    VoidCallback? onTrailing,
    String? autofill,
  }) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: w),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: theme.secondaryText,
                ),
              ),
            ),
            if (trailingLabel != null)
              GestureDetector(
                onTap: onTrailing,
                child: Text(
                  trailingLabel,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: theme.secondaryText,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          focusNode: focus,
          keyboardType: keyboard,
          obscureText: obscure ?? false,
          autofillHints: autofill == null ? null : [autofill],
          cursorColor: theme.primary,
          style: GoogleFonts.inter(fontSize: 16, color: theme.primaryText),
          decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16,
              color: theme.secondaryText.withOpacity(0.6),
            ),
            filled: true,
            fillColor: theme.secondaryBackground,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            enabledBorder: border(theme.alternate),
            focusedBorder: border(theme.primary, 1.5),
            suffixIcon: onToggle == null
                ? null
                : IconButton(
                    tooltip: (obscure ?? false)
                        ? 'Show password'
                        : 'Hide password',
                    onPressed: onToggle,
                    icon: Icon(
                      (obscure ?? false)
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: theme.secondaryText,
                    ),
                  ),
          ),
          onFieldSubmitted: (_) => _submit(),
        ),
      ],
    );
  }

  Widget _primaryButton(FlutterFlowTheme theme) {
    return SizedBox(
      height: 46,
      child: Material(
        color: theme.primary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: _pending ? null : _submit,
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _pending
                ? [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _signUp ? 'Creating Account...' : 'Signing In...',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ]
                : [
                    Text(
                      _signUp ? 'Create Account' : 'Sign In',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _separator(FlutterFlowTheme theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.alternate, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or Continue With',
            style: GoogleFonts.inter(fontSize: 12, color: theme.secondaryText),
          ),
        ),
        Expanded(child: Divider(color: theme.alternate, height: 1)),
      ],
    );
  }

  Widget _googleButton(FlutterFlowTheme theme) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: _google,
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryText,
          side: BorderSide(color: theme.alternate),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const FaIcon(FontAwesomeIcons.google, size: 16),
        label: Text(
          'Google',
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _footer(FlutterFlowTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            _signUp ? 'Already Have an Account? ' : 'No Account Yet? ',
            style: GoogleFonts.inter(fontSize: 13, color: theme.secondaryText),
          ),
          GestureDetector(
            onTap: () => setState(() => _signUp = !_signUp),
            child: Text(
              _signUp ? 'Sign In' : 'Create One',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.primaryText,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Faint 32px grid that fades out toward the edges, as in the 21st card.
class _GridBackdrop extends StatelessWidget {
  const _GridBackdrop();

  @override
  Widget build(BuildContext context) {
    final line = FlutterFlowTheme.of(context).alternate;
    return IgnorePointer(
      child: ShaderMask(
        shaderCallback: (rect) => const RadialGradient(
          radius: 0.75,
          colors: [Colors.black, Colors.transparent],
          stops: [0.3, 1],
        ).createShader(rect),
        blendMode: BlendMode.dstIn,
        child: Opacity(
          opacity: 0.6,
          child: CustomPaint(painter: _GridPainter(line)),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x <= size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y <= size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => old.color != color;
}
