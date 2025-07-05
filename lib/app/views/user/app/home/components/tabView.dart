import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TabViewHome extends StatefulWidget {
  final Function(int, String?) onTabChanged;
  
  const TabViewHome({
    super.key,
    required this.onTabChanged,
  });

  @override
  State<TabViewHome> createState() => _TabViewHomeState();
}

class _TabViewHomeState extends State<TabViewHome> {
  List<Map<String, dynamic>> jenisOlahraga = [];
  bool isLoading = true;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadJenisOlahraga();
  }

  Future<void> _loadJenisOlahraga() async {
    try {
      final response = await Supabase.instance.client
          .from('jenis_olahraga')
          .select('id_jenis_olahraga, nama_jenis')
          .eq('aktif', true)
          .order('nama_jenis');

      if (mounted) {
        setState(() {
          jenisOlahraga = [
            {'id_jenis_olahraga': null, 'nama_jenis': 'Semua'},
            ...response,
          ];
          isLoading = false;
        });

        // Trigger initial load
        widget.onTabChanged(0, null);
      }
    } catch (e) {
      print('Error loading jenis olahraga: $e');
      if (mounted) {
        setState(() {
          jenisOlahraga = [
            {'id_jenis_olahraga': null, 'nama_jenis': 'Semua'},
          ];
          isLoading = false;
        });
        widget.onTabChanged(0, null);
      }
    }
  }

  void _onTabTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    
    final selectedJenis = jenisOlahraga[index];
    widget.onTabChanged(index, selectedJenis['id_jenis_olahraga']);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 40,
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088E8)),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: jenisOlahraga.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final jenis = jenisOlahraga[index];
          final isSelected = selectedIndex == index;
          
          return GestureDetector(
            onTap: () => _onTabTap(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? const Color(0xFF0088E8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected 
                      ? const Color(0xFF0088E8)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  jenis['nama_jenis'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected 
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
