import 'package:flutter/material.dart';

class ConfirmTab extends StatefulWidget {
  final void Function(String? filter) onFilterChanged;

  const ConfirmTab({super.key, required this.onFilterChanged});

  @override
  State<ConfirmTab> createState() => _ConfirmTabState();
}

class _ConfirmTabState extends State<ConfirmTab> {
  int selectedIndex = 0;

  final List<String> filterOptions = ['Semua', 'Menunggu', 'Selesai', 'Ditolak'];

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
                
                // Handle filter logic
                String? filter;
                if (option == 'Semua') {
                  filter = null;
                } else {
                  filter = option.toLowerCase();
                }
                
                widget.onFilterChanged(filter);
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
}