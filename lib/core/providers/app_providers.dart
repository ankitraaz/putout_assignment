import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kuttot/data/models/category_model.dart';
import 'package:kuttot/data/models/reward_model.dart';
import 'package:kuttot/data/models/store_model.dart';
import 'package:kuttot/data/models/plan_model.dart';
import 'package:kuttot/data/repositories/data_repository.dart';

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final repository = ref.read(dataRepositoryProvider);
  return repository.getCategories();
});

final storesProvider = FutureProvider<List<StoreModel>>((ref) async {
  final repository = ref.read(dataRepositoryProvider);
  return repository.getStores();
});

final rewardsProvider = FutureProvider<List<RewardModel>>((ref) async {
  final repository = ref.read(dataRepositoryProvider);
  return repository.getRewards();
});

final plansProvider = FutureProvider<List<PlanModel>>((ref) async {
  final repository = ref.read(dataRepositoryProvider);
  return repository.getPlans();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedCategoryProvider = StateProvider<String?>((ref) => 'All');

final filteredStoresProvider = Provider<AsyncValue<List<StoreModel>>>((ref) {
  final storesAsync = ref.watch(storesProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final selectedCategory = ref.watch(selectedCategoryProvider);

  return storesAsync.whenData((stores) {
    return stores.where((store) {
      final matchesQuery = searchQuery.isEmpty || 
          store.name.toLowerCase().contains(searchQuery) ||
          store.category.toLowerCase().contains(searchQuery);
          
      final matchesCategory = selectedCategory == null || 
          selectedCategory == 'All' || 
          store.category == selectedCategory;
          
      return matchesQuery && matchesCategory;
    }).toList();
  });
});
