import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gofield/app/views/user/app/home/components/tabView.dart';
import 'package:gofield/core/components/components.dart';
import 'package:gofield/core/router/app_routes.dart';
import 'package:gofield/app/views/user/components/components/cartIcon.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final FocusNode _focusNode = FocusNode();
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSearchFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Search Bar and Cart Icon using Stack
              SizedBox(
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back Arrow
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      left: _isSearchFocused ? -50 : 16,
                      top: 10,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _isSearchFocused ? 0 : 1,
                        child: GestureDetector(
                          onTap: () => context.go(AppRoutes.userDashboard),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.arrow_back, size: 20),
                          ),
                        ),
                      ),
                    ),

                    // Search Bar
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: _isSearchFocused ? 16 : 64,
                      right: _isSearchFocused ? 16 : 64,
                      top: 10,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(21),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextField(
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            hintText: 'Cari lapangan di Go Field',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Cart Icon
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 300),
                      right: _isSearchFocused ? -50 : 16,
                      top: 10,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _isSearchFocused ? 0 : 1,
                        child: CartButton(
                          itemCount: 4,
                          onTap: () => context.go(AppRoutes.userCartPage),
                          iconColor: Colors.black,
                          iconSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab View
              TabViewHome(onTabChanged: (index) {}),

              // GridView + Blur
              Expanded(
                child: Stack(
                  children: [
                    _buildGridContent(),

                    // Blur layer
                    IgnorePointer(
                      ignoring: !_isSearchFocused,
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: _isSearchFocused ? 1.0 : 0.0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.67,
        ),
        itemBuilder: (context, index) {
          return GlobalCard(
            padding: const EdgeInsets.all(8),
            backgroundColor: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      'assets/images/contoh.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Glagah Futsal',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.favorite_border, size: 16),
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Rp 10.000',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.yellow[600],
                              ),
                              SizedBox(width: 2),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.circle, size: 3, color: Colors.grey),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '1rb Pemesanan',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Glagah Team',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.pin_drop_outlined, size: 12),
                          SizedBox(width: 2),
                          Text(
                            '0.1 Km',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
