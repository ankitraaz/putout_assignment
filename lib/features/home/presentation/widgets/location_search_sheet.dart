import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/location_provider.dart';

class LocationSearchSheet extends ConsumerStatefulWidget {
  const LocationSearchSheet({super.key});

  @override
  ConsumerState<LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends ConsumerState<LocationSearchSheet> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _popularCities = [
     'MUZAFFARPUR',
    'HAJIPUR',
    'PATNA',
    'DELHI',
    'MUMBAI',
    'BANGALORE',
    'KOLKATA',
    'CHENNAI',
    'PUNE',
    'HYDERABAD',
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _popularCities;
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _popularCities;
      } else {
        _filteredCities = _popularCities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          const Text(
            'SELECT LOCATION',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.kutootMaroon,
              letterSpacing: 1,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: _onSearch,
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                ref.read(locationProvider.notifier).updateLocation(value);
                Navigator.pop(context);
              }
            },
            decoration: InputDecoration(
              hintText: 'Search city or area...',
              prefixIcon: const Icon(Icons.search, color: AppColors.locationOrange),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Use current location button
          ListTile(
            onTap: () {
              ref.read(locationProvider.notifier).refreshLocation();
              Navigator.pop(context);
            },
            leading: const Icon(Icons.my_location, color: AppColors.locationOrange),
            title: const Text(
              'Use Current Location',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.locationOrange,
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          
          const Divider(),
          
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'POPULAR CITIES',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
          
          // Cities List
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCities.length,
              itemBuilder: (context, index) {
                final city = _filteredCities[index];
                return ListTile(
                  onTap: () {
                    ref.read(locationProvider.notifier).updateLocation(city);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.location_city, size: 20),
                  title: Text(
                    city,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
