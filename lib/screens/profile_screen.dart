import 'package:flutter/material.dart';
import 'package:belajar_web/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final String email;

  const ProfileScreen({super.key, required this.email});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isChangingEmail = false;
  final AuthService _authService = AuthService();
  bool _isChangingPassword = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Definisi warna pastel
  final Color _pastelPrimary = const Color(0xFF8B9FE8); // Biru pastel
  final Color _pastelSecondary = const Color(0xFFE8C4A2); // Peach pastel
  final Color _pastelAccent = const Color(0xFFA2E8C4); // Hijau pastel
  final Color _pastelBackground1 = const Color(0xFFD8E3FF); // Biru muda pastel
  final Color _pastelBackground2 = const Color(0xFFFFF0E5); // Peach muda pastel
  final Color _pastelText = const Color(0xFF5D6B98); // Biru tua pastel untuk teks

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    
    // Memastikan email yang ditampilkan adalah yang terbaru
    _loadCurrentEmail();
  }
  
  // Memuat email terbaru dari current user
  Future<void> _loadCurrentEmail() async {
    // Method getEmail sudah tidak ada, gunakan email dari widget
    setState(() {
      _emailController.text = widget.email;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleEmailChange() {
    setState(() {
      _isChangingEmail = !_isChangingEmail;
      if (!_isChangingEmail) {
        _emailController.text = widget.email;
      }
    });
  }

  void _togglePasswordChange() {
    setState(() {
      _isChangingPassword = !_isChangingPassword;
      if (!_isChangingPassword) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  Future<void> _saveEmailChanges() async {
    if (_formKey.currentState!.validate()) {
      final newEmail = _emailController.text;
      
      // Simulasi penyimpanan email (untuk demo)
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        _isChangingEmail = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Email berhasil diperbarui'),
          backgroundColor: _pastelPrimary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _savePasswordChanges() async {
    if (_formKey.currentState!.validate()) {
      final currentPassword = _currentPasswordController.text;
      final newPassword = _newPasswordController.text;
      
      // Verifikasi password saat ini
      final isCurrentPasswordValid = await _authService.verifyCredentials(widget.email, currentPassword);
      
      if (!isCurrentPasswordValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password saat ini tidak valid'),
            backgroundColor: Colors.red.shade300,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }
      
      // Simulasi penyimpanan password baru (untuk demo)
      await Future.delayed(const Duration(milliseconds: 500));
      final success = true;
      
      if (success) {
        setState(() {
          _isChangingPassword = false;
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password berhasil diperbarui'),
            backgroundColor: _pastelPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Gagal memperbarui password'),
            backgroundColor: Colors.red.shade300,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  // Widget untuk judul section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _pastelText,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profil Pengguna',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: _pastelPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: _pastelPrimary.withOpacity(0.4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _pastelBackground1,
              _pastelBackground2,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: Row(
          children: [
            // Ruang kosong di kiri (20%)
            const Spacer(flex: 1),
            
            // Konten utama (60%)
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profil Header
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    _pastelPrimary.withOpacity(0.7),
                                    _pastelPrimary,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _pastelPrimary.withOpacity(0.4),
                                    blurRadius: 15,
                                    spreadRadius: 3,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              widget.email,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _pastelText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Email Section
                      _buildSectionTitle('Email'),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4,
                        shadowColor: _pastelPrimary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Alamat Email',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _pastelText,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: _toggleEmailChange,
                                    icon: Icon(_isChangingEmail ? Icons.close : Icons.edit),
                                    label: Text(_isChangingEmail ? 'Batal' : 'Ubah'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: _isChangingEmail ? Colors.red.shade300 : _pastelPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (_isChangingEmail) ...[
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email Baru',
                                    labelStyle: TextStyle(color: _pastelText.withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.email, color: _pastelPrimary),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary.withOpacity(0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary, width: 2),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email tidak boleh kosong';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Masukkan email yang valid';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _saveEmailChanges,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _pastelPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text('Simpan Perubahan'),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  widget.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _pastelText.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Password Section
                      _buildSectionTitle('Password'),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 4,
                        shadowColor: _pastelPrimary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _pastelText,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: _togglePasswordChange,
                                    icon: Icon(_isChangingPassword ? Icons.close : Icons.edit),
                                    label: Text(_isChangingPassword ? 'Batal' : 'Ubah'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: _isChangingPassword ? Colors.red.shade300 : _pastelPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (_isChangingPassword) ...[
                                // Current Password
                                TextFormField(
                                  controller: _currentPasswordController,
                                  obscureText: _obscureCurrentPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password Saat Ini',
                                    labelStyle: TextStyle(color: _pastelText.withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.lock, color: _pastelPrimary),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                                        color: _pastelPrimary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureCurrentPassword = !_obscureCurrentPassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary.withOpacity(0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password saat ini tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // New Password
                                TextFormField(
                                  controller: _newPasswordController,
                                  obscureText: _obscureNewPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password Baru',
                                    labelStyle: TextStyle(color: _pastelText.withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline, color: _pastelPrimary),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                                        color: _pastelPrimary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureNewPassword = !_obscureNewPassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary.withOpacity(0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password baru tidak boleh kosong';
                                    }
                                    if (value.length < 6) {
                                      return 'Password minimal 6 karakter';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                // Confirm Password
                                TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Konfirmasi Password',
                                    labelStyle: TextStyle(color: _pastelText.withOpacity(0.7)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    prefixIcon: Icon(Icons.lock_outline, color: _pastelPrimary),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                        color: _pastelPrimary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary.withOpacity(0.3)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: _pastelPrimary, width: 2),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Konfirmasi password tidak boleh kosong';
                                    }
                                    if (value != _newPasswordController.text) {
                                      return 'Password tidak cocok';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _savePasswordChanges,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _pastelPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: const Text('Simpan Perubahan'),
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  '••••••••',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 2,
                                    color: _pastelText.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Ruang kosong di kanan (20%)
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}