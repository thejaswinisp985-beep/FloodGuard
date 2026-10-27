import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final smtpServer = gmail('thejaswinisp2026@gmail.com', 'gexw hhoj wkvy wdqy');

  static Future<bool> sendFloodAlert({
    required List<String> recipients,
    required String riskLevel,
  }) async {
    if (recipients.isEmpty) return false;

    final message = Message()
      ..from = Address('thejaswinisp2026@gmail.com', 'FloodGuard Alert')
      ..recipients.addAll(recipients)
      ..subject = 'FLOOD ALERT: $riskLevel Risk!'
      ..text = 'URGENT: $riskLevel flood risk detected. Take immediate precautions. Stay safe! - FloodGuard';

    try {
      final sendReport = await send(message, smtpServer);
      print('Alert emails sent: $sendReport');
      return true;
    } catch (e) {
      print('Failed to send alert emails: $e');
      return false;
    }
  }

  static Future<bool> sendEmergencyContacts({
    required List<String> recipients,
    required String subject,
    required String body,
  }) async {
    if (recipients.isEmpty) return false;

    final message = Message()
      ..from = Address('thejaswinisp2026@gmail.com', 'FloodGuard')
      ..recipients.addAll(recipients)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Emails sent: $sendReport');
      return true;
    } catch (e) {
      print('Failed to send emails: $e');
      return false;
    }
  }
}