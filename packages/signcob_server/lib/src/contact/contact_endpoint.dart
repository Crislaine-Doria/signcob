import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Receives contact requests without exposing stored messages publicly.
class ContactEndpoint extends Endpoint {
  Future<void> submit(
    Session session,
    String name,
    String email,
    String message,
  ) async {
    final normalizedName = name.trim();
    final normalizedEmail = email.trim();
    final normalizedMessage = message.trim();
    if (normalizedName.isEmpty ||
        normalizedName.length > 120 ||
        normalizedEmail.length > 254 ||
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(normalizedEmail) ||
        normalizedMessage.isEmpty ||
        normalizedMessage.length > 5000) {
      throw ArgumentError('Dados de contato inválidos.');
    }
    await ContactMessage.db.insertRow(
      session,
      ContactMessage(
        name: normalizedName,
        email: normalizedEmail,
        message: normalizedMessage,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }
}
