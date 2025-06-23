import 'package:flutter/material.dart';

class TransaksiTab extends StatefulWidget {
  const TransaksiTab({super.key});

  @override
  State<TransaksiTab> createState() => _TransaksiTabState();
}

class _TransaksiTabState extends State<TransaksiTab> {
  int selectedIndex = 0;
  
  final List<String> filterOptions = [
    'Semua',
    '7 Hari',
    '1 Bulan',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filterOptions.asMap().entries.map((entry) {
          int index = entry.key;
          String option = entry.value;
          
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                // TODO: Implement filter logic here
                _onFilterChanged(option);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedIndex == index 
                          ? Colors.blue
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedIndex == index 
                        ? Colors.blue
                        : Colors.grey[600],
                    fontWeight: selectedIndex == index 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  void _onFilterChanged(String filter) {
    // TODO: Implement your filter logic here
    print('Filter changed to: $filter');
    // Nanti bisa menggunakan callback atau state management
    // untuk mengirim filter ke parent widget
  }
}