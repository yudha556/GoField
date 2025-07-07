class ChatMessage {
  final String id;
  final String percakapanId;
  final String pengirimId;
  final String isi;
  final DateTime timestamp;
  final bool dibaca;

  ChatMessage({
    required this.id,
    required this.percakapanId,
    required this.pengirimId,
    required this.isi,
    required this.timestamp,
    required this.dibaca,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id_pesan'],
      percakapanId: map['id_percakapan'],
      pengirimId: map['pengirim'],
      isi: map['isi_pesan'],
      timestamp: DateTime.parse(map['waktu_kirim']),
      dibaca: map['dibaca'] ?? false,
    );
  }
}
