import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gofield/app/views/user/layout/main_user_scaffold.dart';
import 'dart:ui';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light, // IOS
      ),
      child: const MainUserScaffold(child: SafeArea(child: SearchContent())),
    );
  }
}

class SearchContent extends StatefulWidget {
  const SearchContent({super.key});

  @override
  State<SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends State<SearchContent>
    with TickerProviderStateMixin {
  bool _isSearchActive = false;
  late AnimationController _animationController;
  late AnimationController _blurController;
  late Animation<double> _micAnimation;
  late Animation<double> _blurAnimation;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // Sample search history data
  final List<String> _searchHistory = [
    'Lapangan Futsal Jakarta',
    'Badminton Arena Tangerang',
    'Basket Court Bekasi',
    'Tennis Court Depok',
    'Volley Ball Bogor',
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _blurController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _micAnimation = Tween<double>(
      begin: 1.0, 
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _blurAnimation = Tween<double>(begin: 0.0, end: 5.0).animate(
      CurvedAnimation(parent: _blurController, curve: Curves.easeInOut),
    );

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus && !_isSearchActive) {
        _activateSearch();
      }
    });
  }

  void _activateSearch() {
    setState(() {
      _isSearchActive = true;
    });
    _animationController.forward();
    _blurController.forward();
  }

  void _deactivateSearch() {
    setState(() {
      _isSearchActive = false;
    });
    _animationController.reverse();
    _blurController.reverse();
    _searchFocusNode.unfocus();
  }

  void _removeSearchHistory(int index) {
    setState(() {
      _searchHistory.removeAt(index);
    });
  }

  void _selectSearchHistory(String query) {
    _searchController.text = query;
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _blurController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content dengan blur
          Column(
            children: [
              Container(
                height: 80, 
                color: Colors.transparent,
              ),

              // Content area yang akan di-blur
              Expanded(
                child: AnimatedBuilder(
                  animation: _blurAnimation,
                  builder: (context, child) {
                    return Stack(
                      children: [
                        // Content area
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Greeting section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.withOpacity(0.1),
                                      Colors.blue.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cari Lapangan Favoritmu',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.grey[800],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Temukan lapangan olahraga terbaik di sekitarmu',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        Icons.sports_soccer,
                                        color: Colors.blue[600],
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Popular categories
                              Text(
                                'Kategori Populer',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 12),
                              
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 3.5,
                                children: [
                                  _buildCategoryCard('Futsal', Icons.sports_soccer, Colors.green),
                                  _buildCategoryCard('Badminton', Icons.sports_tennis, Colors.blue),
                                  _buildCategoryCard('Basket', Icons.sports_basketball, Colors.orange),
                                  _buildCategoryCard('Tenis', Icons.sports_tennis, Colors.purple),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Search history section
                              if (_searchHistory.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Pencarian Terakhir',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _searchHistory.clear();
                                        });
                                      },
                                      child: Text(
                                        'Hapus Semua',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Search history list
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _searchHistory.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 5),
                                  itemBuilder: (context, index) {
                                    return _buildSearchHistoryItem(
                                      _searchHistory[index],
                                      index,
                                    );
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Blur overlay (HANYA untuk konten)
                        if (_blurAnimation.value > 0)
                          Positioned.fill(
                            child: GestureDetector(
                              onTap: _deactivateSearch,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: _blurAnimation.value,
                                  sigmaY: _blurAnimation.value,
                                ),
                                child: Container(
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          // Header dengan search bar (TIDAK ikut blur - positioned di atas)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: AnimatedBuilder(
                animation: _micAnimation,
                builder: (context, child) {
                  return Row(
                    children: [
                      // Search bar
                      Expanded(
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: _isSearchActive
                                  ? Colors.black
                                  : Colors.grey[300]!,
                              width: _isSearchActive ? 1.2 : 1,
                            ),
                            boxShadow: _isSearchActive
                                ? [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Cari lapangan olahraga...',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: _isSearchActive
                                    ? Colors.black
                                    : Colors.grey[500],
                              ),
                              suffixIcon: _isSearchActive &&
                                      _searchController.text.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.clear),
                                      color: Colors.grey[500],
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 0,
                              ),
                              isCollapsed: true,
                            ),
                            onTap: () {
                              if (!_isSearchActive) {
                                _activateSearch();
                              }
                            },
                            onChanged: (value) {
                              setState(() {}); 
                            },
                          ),
                        ),
                      ),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _micAnimation.value * 48, 
                        child: _micAnimation.value > 0.1 
                            ? Opacity(
                                opacity: _micAnimation.value,
                                child: IconButton(
                                  onPressed: () {
                                    print('Mic button pressed');
                                  },
                                  icon: const Icon(Icons.mic),
                                  color: Colors.grey[600],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        _searchController.text = title;
        _activateSearch();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistoryItem(String query, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(query),
        trailing: IconButton(
          onPressed: () {
            _removeSearchHistory(index);
          },
          icon: const Icon(Icons.close),
          color: Colors.grey[600],
        ),
        onTap: () {
          _selectSearchHistory(query);
        },
      ),
    );
  }
}
