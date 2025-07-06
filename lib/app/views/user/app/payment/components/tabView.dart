import 'package:flutter/material.dart';
import 'package:gofield/core/models/lapanganDetail_model.dart';
import 'package:gofield/app/views/user/app/payment/components/laneCardUser.dart';

class TransaksiTab extends StatefulWidget {
  final List<LaneDetailModel> lanes;
  final Function(LaneDetailModel)? onEditLane;
  final Function(LaneDetailModel)? onDeleteLane;
  final Function(LaneDetailModel, bool)? onToggleStatus;
  final Function(LaneDetailModel)? onLaneSelected;
  final int? selectedLaneIndex;

  const TransaksiTab({
    super.key,
    required this.lanes,
    this.onEditLane,
    this.onDeleteLane,
    this.onToggleStatus,
    this.onLaneSelected,
    this.selectedLaneIndex,
  });

  @override
  State<TransaksiTab> createState() => _TransaksiTabState();
}

class _TransaksiTabState extends State<TransaksiTab>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.lanes.length,
      vsync: this,
    );

    if (widget.selectedLaneIndex != null &&
        widget.selectedLaneIndex! < widget.lanes.length) {
      _tabController.index = widget.selectedLaneIndex!;
    }

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging &&
          _tabController.index >= 0 &&
          _tabController.index < widget.lanes.length) {
        widget.onLaneSelected?.call(widget.lanes[_tabController.index]);
      }
    });
  }

  @override
  void didUpdateWidget(TransaksiTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lanes.length != widget.lanes.length) {
      _tabController.dispose();
      _tabController = TabController(
        length: widget.lanes.length,
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lanes.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0088E8).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0088E8).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.view_module,
                    color: Color(0xFF0088E8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lane Lapangan (${widget.lanes.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: const Color(0xFF0088E8),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF0088E8),
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              tabs: widget.lanes.map((lane) {
                return Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: lane.aktif ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(lane.namaLane),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Tab View Content
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: widget.lanes.map((lane) {
                return LaneInfoCard(
                  lane: lane,
                  // onEdit: widget.onEditLane != null
                  //     ? () => widget.onEditLane!(lane)
                  //     : null,
                  // onDelete: widget.onDeleteLane != null
                  //     ? () => widget.onDeleteLane!(lane)
                  //     : null,
                  // onToggleStatus: widget.onToggleStatus != null
                  //     ? (status) => widget.onToggleStatus!(lane, status)
                  //     : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.view_module_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Lane',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lapangan ini belum memiliki lane.\nTambahkan lane untuk mulai menerima reservasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0088E8), Color(0xFF4DACEF)],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // TODO: Navigate to add lane
                },
                borderRadius: BorderRadius.circular(8),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Tambah Lane',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
