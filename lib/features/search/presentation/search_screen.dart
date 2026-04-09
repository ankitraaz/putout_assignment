import 'package:flutter/material.dart';
import 'package:kuttot/core/constants/app_strings.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.search),
      ),
      body: const Center(
        child: Text('Search Screen - Use Home Search Bar'),
      ),
    );
  }
}
