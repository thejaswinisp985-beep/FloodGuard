import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<String> _contacts = [];
  final List<TextEditingController> _controllers = List.generate(3, (_) => TextEditingController());

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    _contacts = List.from(authProvider.userData['emergencyContacts'] ?? []);
    for (int i = 0; i < _contacts.length && i < 3; i++) {
      _controllers[i].text = _contacts[i];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Contacts', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: theme.brightness == Brightness.dark
                  ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                  : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Emergency Contacts',
                  style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add up to 3 email addresses to notify in case of flood alerts',
                  style: GoogleFonts.roboto(fontSize: 16, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 24),
                ...List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: 'Contact ${index + 1} Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: theme.colorScheme.surface.withOpacity(0.8),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveContacts,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Save Contacts', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveContacts() {
    List<String> contacts = _controllers.map((c) => c.text.trim()).where((c) => c.isNotEmpty).toList();
    if (contacts.length > 3) contacts = contacts.sublist(0, 3);
    context.read<AuthProvider>().updateEmergencyContacts(contacts);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Emergency contacts saved')));
    Navigator.pop(context);
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    super.dispose();
  }
}