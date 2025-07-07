import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:gofield/core/models/chat_model.dart';

final supabase = Supabase.instance.client;

class ChatService {
  final _uuid = Uuid();

  Future<String> getOrCreatePercakapan(String userId, String ownerId) async {
    final existing = await Supabase.instance.client
        .from('percakapan')
        .select()
        .or(
          'and(id_pengguna.eq.$userId,id_pemilik.eq.$ownerId),and(id_pengguna.eq.$ownerId,id_pemilik.eq.$userId)',
        )
        .maybeSingle();

    if (existing != null) {
      return existing['id_percakapan'];
    }

    final newPercakapan = await Supabase.instance.client
        .from('percakapan')
        .insert({'id_pengguna': userId, 'id_pemilik': ownerId})
        .select()
        .single();

    return newPercakapan['id_percakapan'];
  }

  Future<void> sendMessage({
    required String percakapanId,
    required String pengirimId,
    required String isi,
  }) async {
    await supabase.from('pesan').insert({
      'id_percakapan': percakapanId,
      'pengirim': pengirimId,
      'isi_pesan': isi,
      'waktu_kirim': DateTime.now().toIso8601String(),
    });
  }

  Future<List<ChatMessage>> getMessages(String percakapanId) async {
    final data = await supabase
        .from('pesan')
        .select('*')
        .eq('id_percakapan', percakapanId)
        .order('waktu_kirim');

    return (data as List)
        .map((e) => ChatMessage.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Stream<List<ChatMessage>> listenToMessages(String percakapanId) {
    return Supabase.instance.client
        .from('pesan')
        .stream(primaryKey: ['id_pesan'])
        .eq('id_percakapan', percakapanId)
        .order('waktu_kirim', ascending: true)
        .map((rows) => rows.map((row) => ChatMessage.fromMap(row)).toList());
  }

  Future<void> markMessageAsRead(String messageId) async {
    await supabase
        .from('pesan')
        .update({'dibaca': true})
        .eq('id_pesan', messageId);
  }

  Future<void> deleteMessage(String messageId) async {
    await supabase.from('pesan').delete().eq('id_pesan', messageId);
  }

  Future<String> getOrCreateConversation(String userId, String ownerId) async {
    return await getOrCreatePercakapan(userId, ownerId);
  }

  Future<List<Map<String, dynamic>>> getPercakapanOwner(String ownerId) async {
    final percakapanData = await supabase
        .from('percakapan')
        .select()
        .eq('id_pemilik', ownerId)
        .order('updated_at', ascending: false);

    final result = await Future.wait(
      percakapanData.map((e) async {
        final user = await supabase
            .from('pengguna')
            .select('nama_lengkap, image_url')
            .eq('id_pengguna', e['id_pengguna'])
            .maybeSingle();

        final lastMessage = await supabase
            .from('pesan')
            .select('*')
            .eq('id_percakapan', e['id_percakapan'])
            .order('waktu_kirim', ascending: false)
            .limit(1)
            .maybeSingle();

        return {
          'id_percakapan': e['id_percakapan'],
          'nama_lengkap': user?['nama_lengkap'] ?? 'Unknown',
          'image_url': user?['image_url'],
          'last_message': lastMessage?['isi_pesan'] ?? '',
        };
      }),
    );

    return result;
  }

  Stream<List<Map<String, dynamic>>> listenPercakapanForOwner(
    String idPemilik,
  ) {
    return Supabase.instance.client
        .from('percakapan')
        .stream(primaryKey: ['id_percakapan'])
        .eq('id_pemilik', idPemilik)
        .order('updated_at', ascending: false)
        .map((data) async {
          final result = await Future.wait(
            data.map((e) async {
              final user = await Supabase.instance.client
                  .from('pengguna')
                  .select('nama_lengkap, image_url')
                  .eq('id_pengguna', e['id_pengguna'])
                  .maybeSingle();

              final lastMessage = await Supabase.instance.client
                  .from('pesan')
                  .select('*')
                  .eq('id_percakapan', e['id_percakapan'])
                  .order('waktu_kirim', ascending: false)
                  .limit(1)
                  .maybeSingle();

              return {
                'id_percakapan': e['id_percakapan'],
                'nama_lengkap': user?['nama_lengkap'] ?? 'Unknown',
                'image_url': user?['image_url'],
                'last_message': lastMessage?['isi_pesan'] ?? '',
              };
            }),
          );
          return result;
        })
        .asyncMap((f) => f);
  }
}
