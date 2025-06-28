import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';

class Daftarlapangan extends StatefulWidget {
  const Daftarlapangan({super.key});

  @override
  State<Daftarlapangan> createState() => _DaftarlapanganState();
}

class _DaftarlapanganState extends State<Daftarlapangan> {
  final TextEditingController namaLapangan = TextEditingController();
  final TextEditingController deskripsiLapangan = TextEditingController();
  final TextEditingController nomorTelepon = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController hargaPerJam = TextEditingController();
  final TextEditingController kapasitas = TextEditingController();
  final TextEditingController alamatLapangan = TextEditingController();
  final TextEditingController fasilitasLain = TextEditingController();

  String? jenisOlahraga;
  int banyakLapangan = 1;

  // Checkbox state
  bool wc = false;
  bool makananMinuman = false;
  bool parkir = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 100,
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
                  const Positioned(
                    top: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Daftar Lapangan',
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
                    left: 4,
                    child: CustomBackButton(
                      backgroundColor: Colors.transparent,
                      iconColor: Colors.white,
                      onPressed: () {
                        context.go(AppRoutes.userRegisterToOwner);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Upload File (placeholder)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: LinkButton(
                    text: 'Upload Gambar Lapangan',
                    size: ButtonSize.small,
                    onPressed: () {
                      print('Upload file bro...');
                    },
                  ),
                ),
              ),

              // Nama Lapangan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: namaLapangan,
                  decoration: const InputDecoration(labelText: 'Nama Lapangan'),
                ),
              ),

              // Deskripsi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: deskripsiLapangan,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Lapangan',
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Row Jenis Olahraga & Banyak Lapangan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: jenisOlahraga,
                        hint: const Text("Jenis Olahraga"),
                        items: ['Futsal', 'Badminton', 'Basket']
                            .map(
                              (jenis) => DropdownMenuItem(
                                value: jenis,
                                child: Text(jenis),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => jenisOlahraga = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: banyakLapangan,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah Lapangan',
                        ),
                        items: List.generate(10, (i) => i + 1)
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() => banyakLapangan = val ?? 1);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Row No Telepon & Email
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nomorTelepon,
                        decoration: const InputDecoration(
                          labelText: 'Nomor Telepon',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: email,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                  ],
                ),
              ),

              // Harga & Kapasitas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: hargaPerJam,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga per Jam',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: kapasitas,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Kapasitas Pemain',
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Alamat
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: alamatLapangan,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Lapangan',
                  ),
                ),
              ),

              // Fasilitas
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fasilitas Tersedia:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    CheckboxListTile(
                      value: wc,
                      onChanged: (val) => setState(() => wc = val ?? false),
                      title: const Text('Toilet/WC'),
                    ),
                    CheckboxListTile(
                      value: makananMinuman,
                      onChanged: (val) =>
                          setState(() => makananMinuman = val ?? false),
                      title: const Text('Makanan & Minuman'),
                    ),
                    CheckboxListTile(
                      value: parkir,
                      onChanged: (val) => setState(() => parkir = val ?? false),
                      title: const Text('Parkiran Luas'),
                    ),
                    TextField(
                      controller: fasilitasLain,
                      decoration: const InputDecoration(
                        labelText: 'Fasilitas Lainnya (opsional)',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CancelButton(
                    text: 'Batal',
                    size: ButtonSize.medium,
                    onPressed: () {
                      context.go(AppRoutes.userDashboard);
                    },
                  ),
                  SizedBox(width: 12,),
                  PrimaryButton(
                    text: 'Daftar Sekarang',
                    size: ButtonSize.medium,
                    onPressed: () {
                      context.go(AppRoutes.waitingRegister);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
