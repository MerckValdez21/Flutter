import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';
import '../Google Services/auth_service.dart';
import 'homePage.dart';
import 'signupScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;
  bool isLoading = false;
  bool isGoogleLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void showHidePassword() {
    setState(() => hidePassword = !hidePassword);
  }

  void validateInputs() async {
    if (usernameController.text.trim().isEmpty) {
      _showError('Username is required');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showError('Password is required');
      return;
    }

    setState(() => isLoading = true);

    final users = await DatabaseHelper().loginUser(
      usernameController.text.trim(),
      passwordController.text,
    );

    setState(() => isLoading = false);

    if (!mounted) return;

    if (users.isEmpty) {
      _showError('Invalid username or password');
    } else {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        title: 'Welcome Back!',
        desc: 'Login successful.',
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const Homepage()),
          );
        },
      ).show();
    }
  }

  void _handleGoogleSignIn() async {
    setState(() => isGoogleLoading = true);
    final user = await AuthService().signInWithGoogle();

    if (user != null) {
      developer.log('Logged in: ${user.email}', name: 'LoginScreen');

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Logged in: ${user.email}')));

        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<Homepage>(
            builder: (_) {
              return Homepage();
            },
          ),
        );
      }

      return;
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isGoogleLoading = false);
    if (!mounted) return;
    _showError('Google Sign-In not configured yet.');
  }

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: 'Error',
      desc: message,
      btnOkOnPress: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Gradient background ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Decorative glowing orbs ──────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(size: 260, color: const Color(0xFF7C3AED)),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: _GlowOrb(size: 220, color: const Color(0xFF2563EB)),
          ),
          Positioned(
            top: 200,
            left: 40,
            child: _GlowOrb(size: 80, color: const Color(0xFFEC4899)),
          ),

          // ── Main content ─────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28.0,
                  vertical: 24,
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Logo ────────────────────────────────────
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF7C3AED).withOpacity(0.5),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.bolt_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Heading ──────────────────────────────────
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.55),
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // ── Glass card ──────────────────────────────
                        _GlassCard(
                          child: Column(
                            children: [
                              // Username
                              _StyledTextField(
                                controller: usernameController,
                                label: 'Username',
                                icon: Icons.person_outline_rounded,
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 16),

                              // Password
                              _StyledTextField(
                                controller: passwordController,
                                label: 'Password',
                                icon: Icons.lock_outline_rounded,
                                obscureText: hidePassword,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => validateInputs(),
                                suffixIcon: IconButton(
                                  splashRadius: 20,
                                  onPressed: showHidePassword,
                                  icon: Icon(
                                    hidePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white38,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Forgot password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(0, 0),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot password?',
                                    style: TextStyle(
                                      color: Color(0xFFA78BFA),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),

                              // Login button
                              _GradientButton(
                                label: 'Sign In',
                                isLoading: isLoading,
                                onPressed: isLoading ? null : validateInputs,
                              ),
                              const SizedBox(height: 18),

                              // Divider
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.12),
                                      thickness: 1,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'or continue with',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.4),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.12),
                                      thickness: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Google button
                              _GoogleButton(
                                isLoading: isGoogleLoading,
                                onPressed: isGoogleLoading
                                    ? null
                                    : _handleGoogleSignIn,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Sign up row ──────────────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFFA78BFA),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.35), color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.07),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: const Color(0xFFA78BFA),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFA78BFA), size: 20),
        suffixIcon: suffixIcon,
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withOpacity(0.45),
          fontSize: 14,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(0xFFA78BFA),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFA78BFA), width: 1.5),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GradientButton({
    required this.label,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: onPressed == null
              ? const LinearGradient(
                  colors: [Color(0xFF6B7280), Color(0xFF4B5563)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.45),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GoogleButton({required this.isLoading, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          side: BorderSide(color: Colors.white.withOpacity(0.18), width: 1.2),
          backgroundColor: Colors.white.withOpacity(0.05),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google "G" logo drawn with RichText
                  _GoogleLogo(),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Draw circle segments
    final segments = [
      [0.0, 1.57, const Color(0xFF4285F4)], // blue
      [1.57, 3.14, const Color(0xFF34A853)], // green (approx)
      [3.14, 4.71, const Color(0xFFFBBC05)], // yellow
      [4.71, 6.28, const Color(0xFFEA4335)], // red
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg[2] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.22
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r * 0.72),
        seg[0] as double,
        (seg[1] as double) - (seg[0] as double),
        false,
        paint,
      );
    }

    // White rectangle to simulate the "G" cutout + horizontal bar
    final barPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Mask right portion for "G" opening
    canvas.drawRect(
      Rect.fromLTRB(c.dx, c.dy - r * 0.22, c.dx + r + 2, c.dy + r * 0.22),
      barPaint,
    );

    // Horizontal arm of G
    final armPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(c.dx, c.dy - r * 0.22, c.dx + r * 0.9, c.dy + r * 0.22),
      armPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
