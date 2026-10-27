import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyCard extends StatelessWidget {
  final String service;
  final String number;
  final IconData icon;
  final Color color;

  const EmergencyCard({
    super.key,
    required this.service,
    required this.number,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E3A5F), const Color(0xFF0D47A1)]
                : [Colors.white, const Color(0xFFE3F2FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          title: Text(
            service,
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            'Call $number',
            style: GoogleFonts.roboto(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.call, color: color),
            onPressed: () async {
              final String url = 'tel:$number';
              try {
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch dialer for $number')),
                  );
                }
              } catch (e) {
                // Fallback: show the number for manual dialing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Call $number - Error: ${e.toString()}')),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}