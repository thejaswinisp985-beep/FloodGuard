import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/emergency_card.dart';

class EmergencySupportPage extends StatelessWidget {
  const EmergencySupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Support', style: GoogleFonts.roboto(fontWeight: FontWeight.w600)),
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
                  'Emergency Services',
                  style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'Contact emergency services for immediate assistance',
                  style: GoogleFonts.roboto(fontSize: 16, color: theme.colorScheme.onSurface),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      EmergencyCard(
                        service: 'Police',
                        number: '100',
                        icon: Icons.local_police,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      EmergencyCard(
                        service: 'Fire Department',
                        number: '101',
                        icon: Icons.fire_truck,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      EmergencyCard(
                        service: 'Ambulance',
                        number: '102',
                        icon: Icons.local_hospital,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      EmergencyCard(
                        service: 'Disaster Management',
                        number: '108',
                        icon: Icons.warning,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 16),
                      EmergencyCard(
                        service: 'National Helpline',
                        number: '112',
                        icon: Icons.phone,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}