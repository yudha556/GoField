import 'package:flutter/material.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';

class ScheduleGrid extends StatefulWidget {
  final LaneDetailModel lane;
  final List<String>? selectedJamList;
  final ValueChanged<List<String>>? onJamSelectedList;

  const ScheduleGrid({
    super.key,
    required this.lane,
    this.selectedJamList,
    this.onJamSelectedList,
  });

  @override
  State<ScheduleGrid> createState() => _ScheduleGridState();
}

class _ScheduleGridState extends State<ScheduleGrid> {
  final List<String> pilihJam = [
    '00:00', '01:00', '02:00', '03:00', '04:00', '05:00',
    '06:00', '07:00', '08:00', '09:00', '10:00', '11:00',
    '12:00', '13:00', '14:00', '15:00', '16:00', '17:00',
    '18:00', '19:00', '20:00', '21:00', '22:00', '23:00',
  ];

  late Set<String> selectedJam;

  @override
  void initState() {
    super.initState();
    selectedJam = Set<String>.from(widget.selectedJamList ?? []);
  }

  void _toggleJam(String jam) {
    setState(() {
      if (selectedJam.contains(jam)) {
        selectedJam.remove(jam);
      } else {
        selectedJam.add(jam);
      }
    });

    widget.onJamSelectedList?.call(selectedJam.toList()..sort());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 8,
        childAspectRatio: 1.5,
      ),
      itemCount: pilihJam.length,
      itemBuilder: (context, index) {
        final jam = pilihJam[index];
        final isSelected = selectedJam.contains(jam);

        return GestureDetector(
          onTap: () => _toggleJam(jam),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                jam,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
