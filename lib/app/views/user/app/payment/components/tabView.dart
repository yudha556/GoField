import 'package:flutter/material.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/app/views/user/app/payment/components/laneCardUser.dart';

class TransaksiTab extends StatefulWidget {
  final List<LaneDetailModel> lanes;
  final Function(LaneDetailModel)? onLaneSelected;
  final int? selectedLaneIndex;

  const TransaksiTab({
    super.key,
    required this.lanes,
    this.onLaneSelected,
    this.selectedLaneIndex,
  });

  @override
  State<TransaksiTab> createState() => _TransaksiTabState();
}

class _TransaksiTabState extends State<TransaksiTab> {
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedLaneIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lanes.isEmpty) {
      return const Center(child: Text('Belum ada lane'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            'Pilih Lane:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.lanes.length,
          itemBuilder: (context, index) {
            final lane = widget.lanes[index];
            final isSelected = _selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onLaneSelected?.call(lane);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? const Color(0xFF0088E8) : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: LaneInfoCard(lane: lane),
              ),
            );
          },
        ),
      ],
    );
  }
}
