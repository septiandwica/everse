class AttendanceQRCode {
  final String userId;
  final String eventId;

  AttendanceQRCode({required this.userId, required this.eventId});

  // Konversi ke format yang dapat digunakan oleh QR Code (misalnya JSON)
  Map<String, String> toJson() {
    return {
      'userId': userId,
      'eventId': eventId,
    };
  }
}
