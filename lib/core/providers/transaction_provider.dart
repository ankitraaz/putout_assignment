import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kuttot/data/models/transaction_model.dart';

final transactionProvider = StateNotifierProvider<TransactionNotifier, List<TransactionModel>>((ref) {
  return TransactionNotifier();
});

class TransactionNotifier extends StateNotifier<List<TransactionModel>> {
  TransactionNotifier() : super([]) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('LOCAL_TRANSACTIONS');
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
    await prefs.setStringList('LOCAL_TRANSACTIONS', jsonList);
  }
}
