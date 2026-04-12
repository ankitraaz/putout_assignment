import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuttot/data/models/transaction_model.dart';
import 'package:kuttot/core/providers/auth_provider.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  final authState = ref.watch(authProvider);
  return TransactionNotifier(authState.phone ?? '');
});

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  final String phoneKey;

  TransactionNotifier(this.phoneKey) : super([]) {
    _loadTransactions();
  }

  String _key(String base) => phoneKey.isEmpty ? base : '${base}_$phoneKey';

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key('LOCAL_TRANSACTIONS'));
    if (data != null) {
      state = data
          .map((item) => TransactionModel.fromJson(json.decode(item)))
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Newest first
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final newState = [transaction, ...state]; // Insert at beginning
    state = newState;
    
    final prefs = await SharedPreferences.getInstance();
    final jsonList = newState.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_key('LOCAL_TRANSACTIONS'), jsonList);
  }
}

