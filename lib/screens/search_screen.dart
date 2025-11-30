import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<String> _recentSearches = [
    'Cricket',
    'Football ground near me',
    'Badminton court',
    'Tennis coaching',
  ];
  
  List<Map<String, dynamic>> _popularSearches = [
    {'icon': '🏏', 'title': 'Cricket', 'subtitle': 'Find cricket grounds'},
    {'icon': '⚽', 'title': 'Football', 'subtitle': 'Soccer fields nearby'},
    {'icon': '🏸', 'title': 'Badminton', 'subtitle': 'Courts and coaching'},
    {'icon': '🎾', 'title': 'Tennis', 'subtitle': 'Tennis courts'},
    {'icon': '🏀', 'title': 'Basketball', 'subtitle': 'Basketball courts'},
    {'icon': '🏐', 'title': 'Volleyball', 'subtitle': 'Beach and indoor'},
  ];
  
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field when screen opens
    Future.delayed(const Duration(milliseconds: 100), () {
      _searchFocusNode.requestFocus();
    });
    
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _performSearch(_searchController.text);
      } else {
        _searchResults.clear();
      }
    });
  }

  void _performSearch(String query) {
    // Mock search results - replace with actual API call
    _searchResults = [
      {
        'type': 'venue',
        'name': 'Melbourne Hub Cricket',
        'location': 'Paramount colony, Hyderabad',
        'distance': '2.3 km',
        'rating': 4.5,
      },
      {
        'type': 'venue',
        'name': 'Elite Sports Complex',
        'location': 'Banjara Hills, Hyderabad',
        'distance': '3.7 km',
        'rating': 4.8,
      },
      {
        'type': 'game',
        'name': 'Cricket Match - Tonight',
        'host': 'Sampad',
        'location': 'Malakpet, Hyderabad',
        'time': 'Today, 6:00 PM',
      },
      {
        'type': 'professional',
        'name': 'John - Cricket Coach',
        'speciality': 'Batting & Bowling',
        'rating': 4.9,
        'distance': '1.2 km',
      },
    ].where((item) {
      return item['name'].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _addToRecentSearches(String query) {
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 8) {
        _recentSearches = _recentSearches.sublist(0, 8);
      }
    });
  }

  void _clearRecentSearches() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0x1FA9A9A9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Search field
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x1FA9A9A9),
                        border: Border.all(
                          width: 1.028,
                          color: const Color(0x26FFFFFF),
                        ),
                        borderRadius: BorderRadius.circular(49.345),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            width: 18.504,
                            height: 18.504,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search sports, venues, events…',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 12.336,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.white54,
                                size: 20,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _isSearching && _searchResults.isNotEmpty
                  ? _buildSearchResults()
                  : _isSearching && _searchResults.isEmpty
                      ? _buildNoResults()
                      : _buildDefaultContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: _clearRecentSearches,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: const Color(0xFF94EA01),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._recentSearches.map((search) => _buildRecentSearchItem(search)),
            const SizedBox(height: 32),
          ],
          
          // Popular Searches
          const Text(
            'Popular Searches',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: _popularSearches.length,
            itemBuilder: (context, index) {
              return _buildPopularSearchCard(_popularSearches[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSearchItem(String search) {
    return GestureDetector(
      onTap: () {
        _searchController.text = search;
        _addToRecentSearches(search);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.history,
              color: Colors.white54,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                search,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.arrow_outward,
              color: Colors.white.withOpacity(0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularSearchCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _searchController.text = item['title'];
        _addToRecentSearches(item['title']);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1358CF).withOpacity(0.3),
              const Color(0xFF0A2D69).withOpacity(0.3),
            ],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item['icon'],
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              item['title'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              item['subtitle'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildSearchResultItem(result);
      },
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    final type = result['type'];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1FA9A9A9),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF94EA01).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF94EA01),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              if (result['rating'] != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFC403), size: 14),
                    const SizedBox(width: 4),
                    Text(
                      result['rating'].toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            result['name'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          if (result['location'] != null)
            Row(
              children: [
                Icon(Icons.location_on, 
                    color: Colors.white.withOpacity(0.6), size: 14),
                const SizedBox(width: 4),
                Text(
                  result['location'],
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          if (result['distance'] != null)
            Text(
              result['distance'],
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          if (result['time'] != null)
            Text(
              result['time'],
              style: TextStyle(
                color: const Color(0xFF94EA01),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching for something else',
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
