import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/components/buttons/button.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'package:gofield/core/models/pengguna_model.dart';
import 'package:gofield/core/services/auth_service/auth_service.dart';

class Settingpage extends StatelessWidget {
  const Settingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0088E8),
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(
        showNavBar: false,
        child: SafeArea(child: SettingContent()),
      ),
    );
  }
}

class SettingContent extends StatefulWidget {
  const SettingContent({super.key});

  @override
  State<SettingContent> createState() => _SettingContentState();
}

class _SettingContentState extends State<SettingContent> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  PenggunaModel? _pengguna;
  bool _isloading = true;

  @override
  void initState() {
    super.initState();
    _fetchPengguna();
  }

  Future<void> _fetchPengguna() async {
    final result = await AuthService.getCurrentPengguna();
    setState(() {
      _pengguna = result;
      _isloading = false;

      if (_pengguna != null) {
        firstNameController.text = _pengguna!.namaLengkap;
        addressController.text = _pengguna!.alamat ?? '';
        phoneController.text = _pengguna!.nomorTelepon;
        emailController.text = _pengguna!.userEmail;
      }
    });
  }


// Future<void> _pickAndUploadImage() async {
//   // Masih error ini mbah gpt ga ngatasin soale
//   final status = await Permission.storage.request();

//   if (!status.isGranted) {
//     print('❌ Izin akses foto ditolak.');
//     return;
//   }

//   final picker = ImagePicker();
//   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null && _pengguna != null) {
//     final Uint8List bytes = await pickedFile.readAsBytes();
//     final filePath = 'profilepictures/${_pengguna!.idPengguna}/profile.jpg';

//     try {
//       await Supabase.instance.client.storage
//           .from('profilepictures')
//           .uploadBinary(
//             filePath,
//             bytes,
//             fileOptions: const FileOptions(upsert: true),
//           );

//       final publicUrl = Supabase.instance.client.storage
//           .from('profilepictures')
//           .getPublicUrl(filePath);

//       // update imageUrl ke DB
//       final updated = _pengguna!.copyWith(
//         imageUrl: publicUrl,
//       );

//       final success = await AuthService.updatePengguna(updated);
//       if (success) {
//         setState(() {
//           _pengguna = updated;
//         });
//       }
//     } catch (e) {
//       print('Upload gagal: $e');
//     }
//   }
// }



  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 170,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0088E8),
                      Color(0xFF4DACEF),
                      Colors.white,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),

              Positioned(
                top: 30,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 13,
                left: 18,
                child: CustomBackButton(
                  backgroundColor: Colors.transparent,
                  iconColor: Colors.white,
                  onPressed: () {
                    context.go(AppRoutes.userprofilePage);
                  },
                ),
              ),

              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: EdgeInsets.all(3), 
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 3,
                          ), 
                        ),
                        // foto profile masih eror gatau kenapa ga bisa buka permissions
                        // child: CircleAvatar(
                        //   radius: 50,
                        //   backgroundColor: Colors.grey.shade200,
                        //   backgroundImage: _pengguna?.imageUrl != null
                        //       ? NetworkImage(_pengguna!.imageUrl!)
                        //       : const AssetImage('assets/images/contoh.jpg')
                        //             as ImageProvider,
                        // ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          // onTap: _pickAndUploadImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue, 
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 90), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Alamat
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Nomor Telepon
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true, 
                ),
                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: CancelButton(
                        text: 'Batal',
                        size: ButtonSize.small,
                        onPressed: () {
                          print('batal di tekan');
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Simpan',
                        size: ButtonSize.small,
                        onPressed: () async {
                          setState(() => _isloading = true);

                          final updated = PenggunaModel(
                            idPengguna: _pengguna!.idPengguna,
                            namaLengkap: firstNameController.text.trim(),
                            userEmail: _pengguna!.userEmail,
                            nomorTelepon: phoneController.text.trim(),
                            alamat: addressController.text.trim(),
                            peran: _pengguna!.peran,
                            tanggalDaftar: _pengguna!.tanggalDaftar,
                            aktif: _pengguna!.aktif,
                            imageUrl: _pengguna!.imageUrl,
                          );

                          final success = await AuthService.updatePengguna(
                            updated,
                          );

                          setState(() => _isloading = false);

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? 'Profil berhasil disimpan'
                                    : 'Gagal menyimpan profil',
                              ),
                            ),
                          );

                          if (success) context.go(AppRoutes.userprofilePage);
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
