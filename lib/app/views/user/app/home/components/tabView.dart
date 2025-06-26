
import 'package:flutter/material.dart';

class TabViewHome extends StatefulWidget {
  final Function(int) onTabChanged;
  
  const TabViewHome({
    Key? key,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  State<TabViewHome> createState() => _TabViewHomeState();
}

class _TabViewHomeState extends State<TabViewHome> with SingleTickerProviderStateMixin {
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
          Tab(text: 'Terdekat'),
          Tab(text: 'Diikuti'),
        ],
      ),
    );
  }
}
