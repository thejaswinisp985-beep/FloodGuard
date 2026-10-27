import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'emergency_contacts_page.dart';
import 'starting_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.roboto(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: theme.brightness == Brightness.dark
                ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'App Settings',
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.brightness == Brightness.dark
                          ? [const Color(0xFF1E3A5F), const Color(0xFF0D47A1)]
                          : [Colors.white, const Color(0xFFE3F2FD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: theme.primaryColor,
                        ),
                        title: Text(
                          'Theme Mode',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          style: GoogleFonts.roboto(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        trailing: Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                          activeColor: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Account',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.brightness == Brightness.dark
                          ? [const Color(0xFF1E3A5F), const Color(0xFF0D47A1)]
                          : [Colors.white, const Color(0xFFE3F2FD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.contacts, color: Colors.purple),
                        title: Text(
                          'Emergency Contacts',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const EmergencyContactsPage()),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info, color: Colors.blue),
                        title: Text(
                          'About',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showAboutDialog(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip, color: Colors.green),
                        title: Text(
                          'Privacy Policy',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showPrivacyDialog(context),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info_outline, color: Colors.orange),
                        title: Text(
                          'App Info',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showAppInfoDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme.brightness == Brightness.dark
                          ? [const Color(0xFF1E3A5F), const Color(0xFF0D47A1)]
                          : [Colors.white, const Color(0xFFE3F2FD)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () => _showLogoutDialog(context, authProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About FloodGuard',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'FloodGuard is an innovative mobile application designed to help communities prepare for and respond to flood emergencies. Using advanced AI technology and real-time weather data, we provide accurate flood risk predictions and emergency management tools.\n\nOur mission is to save lives and protect property by giving people the information they need to make informed decisions during flood events.',
          style: GoogleFonts.roboto(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(
            'FloodGuard is committed to protecting your privacy. We collect minimal personal information necessary to provide our services:\n\n• Location data for weather and flood risk assessment\n• Contact information for emergency notifications\n• Basic profile information\n\nWe do not sell, trade, or otherwise transfer your personal information to third parties. Your data is encrypted and stored securely.',
            style: GoogleFonts.roboto(height: 1.5),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'App Information',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Build: 1',
              style: GoogleFonts.roboto(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              '© 2025 FloodGuard Team',
              style: GoogleFonts.roboto(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: GoogleFonts.roboto(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.roboto(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.roboto(),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const StartingPage()),
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: GoogleFonts.roboto(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}