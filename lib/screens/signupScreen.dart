import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';
import 'loginScreen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  bool hidePassword1 = true;
  bool hidePassword2 = true;
  bool isLoading = false;

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();

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
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    usernameController.dispose();
    password1Controller.dispose();
    password2Controller.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    AwesomeDialog(
      width: 320.0,
      context: context,
      title: 'Error',
      desc: message,
      dialogType: DialogType.error,
      btnOkOnPress: () {},
    ).show();
  }

  void inputValidations() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password1 = password1Controller.text;
    final password2 = password2Controller.text;

    if (fullName.isEmpty) return _showError('Full name is required');
    if (username.isEmpty) return _showError('Username is required');
    if (password1.isEmpty) return _showError('Password is required');
    if (password2.isEmpty) return _showError('Please confirm your password');
    if (password1 != password2) return _showError('Passwords do not match');
    if (password1.length < 6) {
      return _showError('Password must be at least 6 characters');
    }

    setState(() => isLoading = true);
    final result = await DatabaseHelper()
        .insertStudent(fullName, username, password1);
    setState(() => isLoading = false);

    if (!mounted) return;

    if (result > 0) {
      AwesomeDialog(
        width: 320.0,
        context: context,
        title: 'Success',
        desc: 'Account created successfully!',
        dialogType: DialogType.success,
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
      ).show();
    } else {
      _showError('Failed to create account. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background gradient ──────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // ── Decorative orbs ──────────────────────────────────────────
          Positioned(
            top: -60,
            left: -80,
            child: _GlowOrb(size: 240, color: const Color(0xFF7C3AED)),
          ),
          Positioned(
            bottom: 40,
            right: -60,
            child: _GlowOrb(size: 200, color: const Color(0xFF0EA5E9)),
          ),
          Positioned(
            top: 160,
            right: 30,
            child: _GlowOrb(size: 70, color: const Color(0xFFF472B6)),
          ),

          // ── Content ──────────────────────────────────────────────────
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0, vertical: 24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0EA5E9),
                                Color(0xFF7C3AED)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0EA5E9)
                                    .withOpacity(0.5),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.person_add_rounded,
                              color: Colors.white, size: 38),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Fill in the details to get started',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Glass card
                        _GlassCard(
                          child: Column(
                            children: [
                              _DarkTextField(
                                controller: fullNameController,
                                label: 'Full Name',
                                icon: Icons.badge_outlined,
                                action: TextInputAction.next,
                              ),
                              const SizedBox(height: 14),
                              _DarkTextField(
                                controller: usernameController,
                                label: 'Username',
                                icon: Icons.person_outline_rounded,
                                action: TextInputAction.next,
                              ),
                              const SizedBox(height: 14),
                              _DarkTextField(
                                controller: password1Controller,
                                label: 'Password',
                                icon: Icons.lock_outline_rounded,
                                obscure: hidePassword1,
                                action: TextInputAction.next,
                                toggleObscure: () => setState(
                                    () => hidePassword1 = !hidePassword1),
                              ),
                              const SizedBox(height: 14),
                              _DarkTextField(
                                controller: password2Controller,
                                label: 'Confirm Password',
                                icon: Icons.lock_outline_rounded,
                                obscure: hidePassword2,
                                action: TextInputAction.done,
                                toggleObscure: () => setState(
                                    () => hidePassword2 = !hidePassword2),
                                onSubmitted: (_) => inputValidations(),
                              ),
                              const SizedBox(height: 24),

                              // Sign Up button
                              _GradientButton(
                                label: 'Create Account',
                                isLoading: isLoading,
                                gradientColors: const [
                                  Color(0xFF0EA5E9),
                                  Color(0xFF7C3AED)
                                ],
                                glowColor: Color(0xFF0EA5E9),
                                onPressed:
                                    isLoading ? null : inputValidations,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFF38BDF8),
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

// ─────────────────────────────────────────────────────────────────────────────
// Shared widgets (local to this file)
// ─────────────────────────────────────────────────────────────────────────────

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
          colors: [color.withOpacity(0.32), color.withOpacity(0)],
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
        border:
            Border.all(color: Colors.white.withOpacity(0.12), width: 1.2),
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

class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputAction action;
  final VoidCallback? toggleObscure;
  final ValueChanged<String>? onSubmitted;

  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.action = TextInputAction.next,
    this.toggleObscure,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: action,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: const Color(0xFF38BDF8),
      decoration: InputDecoration(
        prefixIcon:
            Icon(icon, color: const Color(0xFF38BDF8), size: 20),
        suffixIcon: toggleObscure != null
            ? IconButton(
                splashRadius: 20,
                onPressed: toggleObscure,
                icon: Icon(
                  obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white38,
                  size: 20,
                ),
              )
            : null,
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.45), fontSize: 14),
        floatingLabelStyle: const TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: 12,
            fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFF38BDF8), width: 1.5),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final List<Color> gradientColors;
  final Color glowColor;
  final VoidCallback? onPressed;

  const _GradientButton({
    required this.label,
    required this.isLoading,
    required this.gradientColors,
    required this.glowColor,
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
                  colors: [Color(0xFF6B7280), Color(0xFF4B5563)])
              : LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: onPressed == null
              ? []
              : [
                  BoxShadow(
                    color: glowColor.withOpacity(0.45),
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
                      color: Colors.white, strokeWidth: 2.5))
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