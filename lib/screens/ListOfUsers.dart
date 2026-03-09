import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:valdez_justinmerck/sqlDatabase/databaseHelper.dart';

class Listofusers extends StatelessWidget {
  const Listofusers({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListOfUsersScreen();
  }
}

class ListOfUsersScreen extends StatefulWidget {
  const ListOfUsersScreen({super.key});

  @override
  State<ListOfUsersScreen> createState() => _ListOfUsersScreenState();
}

class _ListOfUsersScreenState extends State<ListOfUsersScreen>
    with SingleTickerProviderStateMixin {
  List<dynamic> students = [];
  List<dynamic> filtered = [];
  bool isLoading = true;
  final searchController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    getAllStudents();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void getAllStudents() async {
    setState(() => isLoading = true);
    final data = await DatabaseHelper().getAllStudents();
    if (mounted) {
      setState(() {
        students = data;
        filtered = data;
        isLoading = false;
      });
      _animController.forward(from: 0);
    }
  }

  void _filterStudents(String query) {
    setState(() {
      filtered = students
          .where((s) =>
              s['fullName']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              s['username']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  void editUser(BuildContext context, int userId, String fullName,
      String username, String password) {
    final fullNameController = TextEditingController(text: fullName);
    final usernameController = TextEditingController(text: username);
    final passwordController = TextEditingController(text: password);
    bool hidePass = true;

    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: const Color(0xFF13102E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 12,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 28,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA78BFA).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.edit_rounded,
                            color: Color(0xFFA78BFA), size: 20),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Edit User',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _SheetField(
                    controller: fullNameController,
                    label: 'Full Name',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 14),
                  _SheetField(
                    controller: usernameController,
                    label: 'Username',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePass,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    cursorColor: const Color(0xFFA78BFA),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: Color(0xFFA78BFA), size: 20),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        onPressed: () =>
                            setSheetState(() => hidePass = !hidePass),
                        icon: Icon(
                          hidePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white38,
                          size: 20,
                        ),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.45),
                          fontSize: 14),
                      floatingLabelStyle: const TextStyle(
                          color: Color(0xFFA78BFA),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFA78BFA), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF7C3AED).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.save_rounded, size: 18),
                        label: const Text('Save Changes',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () async {
                          final updateResult =
                              await DatabaseHelper().updateStudent(
                            userId,
                            fullNameController.text,
                            usernameController.text,
                            passwordController.text,
                          );
                          if (!sheetContext.mounted) return;
                          Navigator.of(sheetContext).pop();
                          if (updateResult > 0) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              title: 'Updated!',
                              desc: 'User successfully updated.',
                              btnOkOnPress: getAllStudents,
                            ).show();
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              title: 'Error',
                              desc: 'Failed to update user.',
                              btnOkOnPress: () {},
                            ).show();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0C29),
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
          Positioned(
            top: -40,
            right: -50,
            child: _GlowOrb(size: 200, color: const Color(0xFF7C3AED)),
          ),
          Positioned(
            bottom: 60,
            left: -50,
            child: _GlowOrb(size: 160, color: const Color(0xFF0EA5E9)),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── Top bar ──────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      // Back
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.12)),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Users',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      // Refresh
                      GestureDetector(
                        onTap: getAllStudents,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA78BFA).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFA78BFA)
                                    .withOpacity(0.25)),
                          ),
                          child: const Icon(Icons.refresh_rounded,
                              color: Color(0xFFA78BFA), size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Search ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: searchController,
                    onChanged: _filterStudents,
                    style:
                        const TextStyle(color: Colors.white, fontSize: 14),
                    cursorColor: const Color(0xFFA78BFA),
                    decoration: InputDecoration(
                      hintText: 'Search by name or username…',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 14),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: Colors.white.withOpacity(0.4), size: 20),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  color: Colors.white38, size: 18),
                              onPressed: () {
                                searchController.clear();
                                _filterStudents('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.07),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFFA78BFA), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ── Count chip ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1)),
                      ),
                      child: Text(
                        '${filtered.length} user${filtered.length != 1 ? 's' : ''} found',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // ── List ─────────────────────────────────────────────
                Expanded(
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFFA78BFA)),
                        )
                      : filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_outline_rounded,
                                      size: 64,
                                      color:
                                          Colors.white.withOpacity(0.2)),
                                  const SizedBox(height: 14),
                                  Text('No users found',
                                      style: TextStyle(
                                          color:
                                              Colors.white.withOpacity(0.4),
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w500)),
                                ],
                              ),
                            )
                          : FadeTransition(
                              opacity: _fadeAnim,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                    16, 4, 16, 24),
                                itemCount: filtered.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (ctx, index) {
                                  final student = filtered[index];
                                  final userId = student['id'] as int;
                                  final fullName =
                                      student['fullName'] as String;
                                  final userName =
                                      student['username'] as String;
                                  final password =
                                      student['password'] as String;

                                  return _UserCard(
                                    fullName: fullName,
                                    userName: userName,
                                    index: index,
                                    onEdit: () => editUser(context,
                                        userId, fullName, userName,
                                        password),
                                    onDelete: () {
                                      AwesomeDialog(
                                        context: context,
                                        title: 'Delete User',
                                        desc:
                                            'Are you sure you want to delete "$fullName"? This cannot be undone.',
                                        dialogType: DialogType.warning,
                                        btnOkText: 'Delete',
                                        btnOkOnPress: () async {
                                          await DatabaseHelper()
                                              .deleteStudent(userId);
                                          getAllStudents();
                                        },
                                        btnCancelOnPress: () {},
                                      ).show();
                                    },
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          ),
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

const List<Color> _avatarPalette = [
  Color(0xFF7C3AED),
  Color(0xFF2563EB),
  Color(0xFF0EA5E9),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFEF4444),
];

class _UserCard extends StatelessWidget {
  final String fullName;
  final String userName;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _UserCard({
    required this.fullName,
    required this.userName,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final avatarColor = _avatarPalette[index % _avatarPalette.length];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.06),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: avatarColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: avatarColor.withOpacity(0.4), width: 1.5),
              ),
              child: Center(
                child: Text(
                  fullName.isNotEmpty
                      ? fullName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: avatarColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@$userName',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _IconBtn(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFFA78BFA),
                  onTap: onEdit,
                ),
                const SizedBox(width: 6),
                _IconBtn(
                  icon: Icons.delete_rounded,
                  color: Colors.red.shade400,
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: const Color(0xFFA78BFA),
      decoration: InputDecoration(
        prefixIcon:
            Icon(icon, color: const Color(0xFFA78BFA), size: 20),
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.45), fontSize: 14),
        floatingLabelStyle: const TextStyle(
            color: Color(0xFFA78BFA),
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
              const BorderSide(color: Color(0xFFA78BFA), width: 1.5),
        ),
      ),
    );
  }
}