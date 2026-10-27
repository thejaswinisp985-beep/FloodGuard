import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import '../providers/auth_provider.dart';
import 'flood_result_page.dart';

class FloodPredictionPage extends StatefulWidget {
  const FloodPredictionPage({super.key});

  @override
  _FloodPredictionPageState createState() => _FloodPredictionPageState();
}

class _FloodPredictionPageState extends State<FloodPredictionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers =
      List.generate(9, (_) => TextEditingController());
  bool _isLoading = false;

  late Interpreter _interpreter;
  final List<String> _labels = ['High', 'Low', 'Medium'];
  final List<String> _featureNames = [
    'Rainfall (mm)',
    'River Level (m)',
    'Dam Water Level (%)',
    'Soil Moisture (%)',
    'Humidity (%)',
    'Wind Speed (kmph)',
    'Above Sea Level (m)',
    'Drainage Capacity (%)',
    'Population Density'
  ];
  final List<String> _infoDescriptions = [
    'Enter rainfall in mm to assess water accumulation risk.',
    'Enter river level in meters for flood potential.',
    'Enter dam water level percentage for overflow risk.',
    'Enter soil moisture percentage for saturation level.',
    'Enter humidity percentage affecting evaporation.',
    'Enter wind speed in kmph for storm intensity.',
    'Enter elevation in meters above sea level.',
    'Enter drainage capacity percentage for water flow.',
    'Enter population density for vulnerability assessment.'
  ];

  late List<double> _scalerMean;
  late List<double> _scalerStd;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/enhanced_flood_model.tflite');
      _scalerMean = [
        82.03598,
        4.93907,
        54.05452,
        65.35334,
        70.14003,
        16.63198,
        309.64796,
        80.88917,
        1051.259
      ];
      _scalerStd = [
        40.26654152071668,
        1.5507544083767746,
        20.109175014644435,
        15.793975745340374,
        17.090900909522002,
        7.0980359452175215,
        164.25306864481527,
        6.348111578343595,
        711.9312578606167
      ];
      setState(() {});
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  List<double> _scaleFeatures(List<double> features) {
    List<double> scaled = [];
    for (int i = 0; i < features.length; i++) {
      scaled.add((features[i] - _scalerMean[i]) / _scalerStd[i]);
    }
    return scaled;
  }

  Future<void> _predict() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<double> features =
          _controllers.map((c) => double.parse(c.text)).toList();
      List<double> scaledFeatures = _scaleFeatures(features);
      var input = [scaledFeatures];
      var output = [List.filled(3, 0.0)];

      _interpreter.run(input, output);

      List<double> probabilities = output[0];
      int predictedIndex = probabilities.indexWhere(
          (prob) => prob == probabilities.reduce((a, b) => a > b ? a : b));

      String result = _labels[predictedIndex];
      if (result == 'Medium' || result == 'High') {
        await _sendAlertEmail(result);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FloodResultPage(result: result)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Prediction error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendAlertEmail(String risk) async {
    final smtpServer =
        gmail('thejaswinisp2026@gmail.com', 'gexw hhoj wkvy wdqy');
    final authProvider = context.read<AuthProvider>();
    final userEmail = authProvider.userData['email'];
    final contacts =
        authProvider.userData['emergencyContacts'] as List<String>? ?? [];
    final recipients = [userEmail, ...contacts]
        .where((e) => e != null && e.isNotEmpty)
        .toList();
    if (recipients.isEmpty) return;

    final message = Message()
      ..from = Address('thejaswinisp2026@gmail.com', 'FloodGuard Alert')
      ..recipients.addAll(recipients)
      ..subject = 'FLOOD ALERT: $risk Risk!'
      ..text =
          'URGENT: $risk flood risk detected. Take immediate precautions. Stay safe! - FloodGuard';

    try {
      final sendReport = await send(message, smtpServer);
      print('Alert emails sent: $sendReport');
    } catch (e) {
      print('Failed to send alert emails: $e');
    }
  }

  void _showInfoDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_featureNames[index]),
        content: Text(_infoDescriptions[index]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flood Risk Prediction',
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter Environmental Parameters',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Provide accurate data for better predictions',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(
                      9,
                      (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: TextFormField(
                              controller: _controllers[index],
                              decoration: InputDecoration(
                                labelText: _featureNames[index],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor:
                                    theme.colorScheme.surface.withOpacity(0.8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () => _showInfoDialog(index),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a value';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          )),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _predict,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Predict Flood Risk',
                              style: GoogleFonts.roboto(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _interpreter.close();
    super.dispose();
  }
}
