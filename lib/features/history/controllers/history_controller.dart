import 'package:get/get.dart';

import '../../../core/services/storage_service.dart';
import '../models/history_item.dart';

class HistoryController extends GetxController {
  final StorageService _storage = Get.find();
  final historyItems = <HistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  void loadHistory() {
    final List<dynamic> rawList = _storage.history;
    historyItems.value = rawList
        .map((e) => HistoryItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> clearHistory() async {
    await _storage.clearHistory();
    historyItems.clear();
  }

  Future<void> deleteItem(String url) async {
    await _storage.removeFromHistory(url);
    historyItems.removeWhere((item) => item.url == url);
  }
}
