import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/owner/layout/main_owner_schalfold.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';
import 'package:gofield/core/services/chatService.dart';

class OwnerChat extends StatelessWidget {
  const OwnerChat({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainOwnerSchallfold(child: SafeArea(child: ChatContent())),
    );
  }
}

class ChatContent extends StatefulWidget {
  const ChatContent({super.key});

  @override
  State<ChatContent> createState() => _ChatContentState();
}

class _ChatContentState extends State<ChatContent> {
  PenggunaModel? pengguna;
  String? currentOwnerId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOwner();
  }

  Future<void> loadOwner() async {
    pengguna = await AuthService.getCurrentPengguna();

    if (pengguna == null || !pengguna!.isPemilik) {
      debugPrint('User ini bukan pemilik');
      setState(() => isLoading = false);
      return;
    }

    final idPemilik = await AuthService.getIdPemilikByPengguna(
      pengguna!.idPengguna,
    );

    if (idPemilik == null) {
      debugPrint('Gagal dapat id_pemilik');
      setState(() => isLoading = false);
      return;
    }

    setState(() {
      currentOwnerId = idPemilik;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (currentOwnerId == null) {
      return const Center(
        child: Text(
          'Tidak dapat memuat data pemilik',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      children: [
        // BACKGROUND GRADIENT
        Container(
          height: 130,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0088E8), Color(0xFF4DACEF), Colors.white],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: Center(
            child: Text(
              'Pesan Masuk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),

        // CHAT LIST
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: ChatService().listenPercakapanForOwner(currentOwnerId!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final percakapanList = snapshot.data!;

            if (percakapanList.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada pesan masuk 📨',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.only(top: 180),
              itemCount: percakapanList.length,
              itemBuilder: (context, index) {
                final data = percakapanList[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      'ChatDetail',
                      extra: {
                        'contactName': data['nama_lengkap'],
                        'contactAvatar': data['image_url'] ?? '',
                        'ownerId': currentOwnerId,
                        'lapanganId': data['id_lapangan'] ?? '',
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: data['image_url'] != null
                                  ? NetworkImage(data['image_url'])
                                  : null,
                              child: data['image_url'] == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['nama_lengkap'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    data['last_message'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
              },
            );
          },
        ),
      ],
    );
  }
}
