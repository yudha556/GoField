class ChatMessage {
  final String isi;
  final String pengirimId;
  final DateTime timestamp;

  ChatMessage({
    required this.isi,
    required this.pengirimId,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      isi: map['isi_pesan'],
      pengirimId: map['pengirim'],
      timestamp: DateTime.parse(map['waktu_kirim']),
    );
  }
}
