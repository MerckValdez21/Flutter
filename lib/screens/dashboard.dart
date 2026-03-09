import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';
import 'loginScreen.dart';
import 'ListOfUsers.dart';
import 'notesScreen.dart';
import '../Google Services/auth_service.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardHome();
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome>
    with SingleTickerProviderStateMixin {
  int totalUsers = 0;
  bool isLoading = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  final AuthService _authService = AuthService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _currentUser = FirebaseAuth.instance.currentUser;
    _loadStats();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadStats() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper().getAllStudents();
    if (mounted) {
      setState(() {
        totalUsers = data.length;
        isLoading = false;
      });
      _animController.forward(from: 0);
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: $e')),
        );
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1E1B3A),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.logout_rounded,
                    color: Colors.red, size: 32),
              ),
              const SizedBox(height: 16),
              const Text('Logout',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Are you sure you want to logout?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 14)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.2)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Logout',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF1A1740),
                  Color(0xFF0F0C29)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Orbs
          Positioned(
            top: -60,
            right: -40,
            child: _GlowOrb(size: 220, color: const Color(0xFF7C3AED)),
          ),
          Positioned(
            bottom: 80,
            left: -60,
            child: _GlowOrb(size: 180, color: const Color(0xFF0EA5E9)),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadStats,
              color: const Color(0xFFA78BFA),
              backgroundColor: const Color(0xFF1E1B3A),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ── AppBar ───────────────────────────────────────
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    pinned: false,
                    floating: true,
                    leading: Builder(
                      builder: (ctx) => IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                          child: const Icon(Icons.menu_rounded,
                              color: Colors.white, size: 20),
                        ),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                    title: const Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        letterSpacing: -0.3,
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: _confirmLogout,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.red.withOpacity(0.25)),
                            ),
                            child: const Icon(Icons.logout_rounded,
                                color: Colors.red, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ── Welcome banner ───────────────────────────
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF7C3AED),
                                  Color(0xFF2563EB)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7C3AED)
                                      .withOpacity(0.4),
                                  blurRadius: 24,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Welcome back 👋',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _currentUser?.displayName ?? 'User',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'You have $totalUsers registered users',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                      Icons.admin_panel_settings_rounded,
                                      color: Colors.white,
                                      size: 32),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Section label ────────────────────────────
                        Text(
                          'OVERVIEW',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Stat cards ───────────────────────────────
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  icon: Icons.people_alt_rounded,
                                  label: 'Total Users',
                                  value: isLoading ? '—' : '$totalUsers',
                                  accentColor: const Color(0xFFA78BFA),
                                  bgStart: const Color(0xFF2D1B69),
                                  bgEnd: const Color(0xFF1E1B3A),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: _StatCard(
                                  icon: Icons.verified_user_rounded,
                                  label: 'Active Users',
                                  value: isLoading ? '—' : '$totalUsers',
                                  accentColor: const Color(0xFF38BDF8),
                                  bgStart: const Color(0xFF0C3059),
                                  bgEnd: const Color(0xFF1E1B3A),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Quick actions label ──────────────────────
                        Text(
                          'QUICK ACTIONS',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ── Action tiles ─────────────────────────────
                        FadeTransition(
                          opacity: _fadeAnim,
                          child: Column(
                            children: [
                              _ActionTile(
                                icon: Icons.people_outline_rounded,
                                label: 'Manage Users',
                                subtitle: 'View, edit and delete accounts',
                                accentColor: const Color(0xFFA78BFA),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ListOfUsersScreen()),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _ActionTile(
                                icon: Icons.note_alt_outlined,
                                label: 'My Notes',
                                subtitle: 'Create and manage your notes',
                                accentColor: const Color(0xFFF59E0B),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const NotesScreen()),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _ActionTile(
                                icon: Icons.refresh_rounded,
                                label: 'Refresh Data',
                                subtitle: 'Sync latest user statistics',
                                accentColor: const Color(0xFF34D399),
                                onTap: _loadStats,
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF13102E),
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.horizontal(right: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drawer header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _currentUser?.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _currentUser!.photoURL!,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person_rounded,
                                  color: Colors.white, size: 32);
                            },
                          ),
                        )
                      : const Icon(Icons.person_rounded,
                          color: Colors.white, size: 32),
                ),
                const SizedBox(height: 14),
                Text(
                  _currentUser?.displayName ?? 'User',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _currentUser?.email ?? 'user@example.com',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          _DrawerTile(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            onTap: () => Navigator.pop(context),
          ),
          _DrawerTile(
            icon: Icons.people_outline_rounded,
            label: 'List of Users',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const ListOfUsersScreen()),
              );
            },
          ),

          const Spacer(),

          Divider(color: Colors.white.withOpacity(0.08), height: 1),
          _DrawerTile(
            icon: Icons.logout_rounded,
            label: 'Logout',
            isDestructive: true,
            onTap: _confirmLogout,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Local widgets
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
          colors: [color.withOpacity(0.3), color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accentColor;
  final Color bgStart;
  final Color bgEnd;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.accentColor,
    required this.bgStart,
    required this.bgEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [bgStart, bgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: accentColor.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accentColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: accentColor,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accentColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.05),
            border:
                Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        )),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 12,
                        )),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.25), size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade400 : Colors.white70;
    return ListTile(
      leading: Icon(icon, color: color, size: 22),
      title: Text(label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.w600, fontSize: 15)),
      onTap: onTap,
      horizontalTitleGap: 4,
    );
  }
}