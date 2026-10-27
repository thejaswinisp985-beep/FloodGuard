import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloodResultPage extends StatelessWidget {
  final String result;

  const FloodResultPage({required this.result, super.key});

  @override
  Widget build(BuildContext context) {
    String title, description, precautions;
    IconData icon;
    Color color;

    if (result == 'Low') {
      title = 'Low Flood Risk';
      description =
          'The area has a low risk of flooding based on current parameters.';
      precautions =
          'Stay informed about weather updates. Monitor local news for any changes.';
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (result == 'Medium') {
      title = 'Medium Flood Risk';
      description = 'The area has a moderate risk of flooding.';
      precautions =
          'Prepare an emergency kit. Have an evacuation plan ready. Avoid low-lying areas during heavy rain.';
      icon = Icons.warning;
      color = Colors.orange;
    } else {
      title = 'High Flood Risk';
      description =
          'The area has a high risk of flooding. Immediate action required.';
      precautions =
          'Evacuate immediately if advised by authorities. Move to higher ground. Follow emergency broadcasts.';
      icon = Icons.error;
      color = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flood Risk Result',
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
            colors: Theme.of(context).brightness == Brightness.dark
                ? [const Color(0xFF0D47A1), const Color(0xFF1565C0)]
                : [const Color(0xFFE3F2FD), const Color(0xFFBBDEFB)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 100, color: color),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  'Precautions and Recommendations:',
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  precautions,
                  style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back to Prediction'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
