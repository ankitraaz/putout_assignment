import 'dart:convert';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kuttot/data/models/category_model.dart';
import 'package:kuttot/data/models/reward_model.dart';
import 'package:kuttot/data/models/store_model.dart';
import 'package:kuttot/data/models/plan_model.dart';
import 'package:kuttot/data/models/deal_model.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) {
  return DataRepository();
});

// Top-level function for background JSON parsing
List<dynamic> _parseJsonData(String jsonString) {
  return json.decode(jsonString) as List<dynamic>;
}

class DataRepository {
  Future<Box> _getCacheBox() async {
    if (!Hive.isBoxOpen('kuttot_cache')) {
      return await Hive.openBox('kuttot_cache');
    }
    return Hive.box('kuttot_cache');
  }

  Future<List<CategoryModel>> getCategories() async {
    final box = await _getCacheBox();
    final String cacheKey = 'categories_data';

    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<dynamic>;
      // Map instantly from memory
      return cachedList.map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    // Fallback: Read asset and parse in background
    final String response = await rootBundle.loadString('assets/data/categories.json');
    final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
    
    // Save to Hive for subsequent instant reads
    await box.put(cacheKey, data);
    return data.map((json) => CategoryModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<List<StoreModel>> getStores() async {
    final box = await _getCacheBox();
    final String cacheKey = 'stores_data';

    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<dynamic>;
      return cachedList.map((json) => StoreModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    // Background parsing for heavy dataset
    final String response = await rootBundle.loadString('assets/data/stores.json');
    final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
    
    await box.put(cacheKey, data);
    return data.map((json) => StoreModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<List<RewardModel>> getRewards() async {
    final box = await _getCacheBox();
    final String cacheKey = 'rewards_data';

    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<dynamic>;
      return cachedList.map((json) => RewardModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    // Heavy list parsing isolated to offload main thread
    final String response = await rootBundle.loadString('assets/data/rewards.json');
    final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
    
    await box.put(cacheKey, data);
    return data.map((json) => RewardModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<List<PlanModel>> getPlans() async {
    final box = await _getCacheBox();
    final String cacheKey = 'plans_data';

    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<dynamic>;
      return cachedList.map((json) => PlanModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    final String response = await rootBundle.loadString('assets/data/plans.json');
    final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
    
    await box.put(cacheKey, data);
    return data.map((json) => PlanModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }

  Future<List<DealModel>> getDeals() async {
    final box = await _getCacheBox();
    final String cacheKey = 'deals_data';

    if (box.containsKey(cacheKey)) {
      final cachedList = box.get(cacheKey) as List<dynamic>;
      return cachedList.map((json) => DealModel.fromJson(Map<String, dynamic>.from(json))).toList();
    }

    final String response = await rootBundle.loadString('assets/data/deals.json');
    final List<dynamic> data = await Isolate.run(() => _parseJsonData(response));
    
    await box.put(cacheKey, data);
    return data.map((json) => DealModel.fromJson(Map<String, dynamic>.from(json))).toList();
  }
}
