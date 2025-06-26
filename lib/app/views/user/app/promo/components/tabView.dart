
import 'package:flutter/material.dart';

class TabViewPromo extends StatefulWidget {
  final Function(int) onTabChanged;
  
  const TabViewPromo({
    super.key,
    required this.onTabChanged,
  });

  @override
  State<TabViewPromo> createState() => _TabViewPromoState();
}

class _TabViewPromoState extends State<TabViewPromo> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      widget.onTabChanged(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        indicatorWeight: 3,
        tabs: const [
          Tab(text: 'Semua'),
          Tab(text: 'Dimiliki'),
          Tab(text: 'Filter'),
        ],
      ),
    );
  }
}
