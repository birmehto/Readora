import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/app_dialogs.dart';
import '../controllers/history_controller.dart';
import '../widgets/history_list_item.dart';

class HistoryPage extends GetView<HistoryController> {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear History',
            onPressed: () {
              AppDialogs.showConfirmDialog(
                title: 'Clear History',
                message: 'Are you sure you want to clear your reading history?',
                confirmText: 'Clear',
                isDestructive: true,
                onConfirm: () {
                  controller.clearHistory();
                  Get.back();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.historyItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No history yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.historyItems.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.historyItems[index];
            return HistoryListItem(
              item: item,
              onDelete: () {
                AppDialogs.showConfirmDialog(
                  title: 'Delete History Item',
                  message:
                      'Are you sure you want to remove this article from your history?',
                  confirmText: 'Delete',
                  isDestructive: true,
                  onConfirm: () {
                    controller.deleteItem(item.url);
                    Get.back();
                  },
                );
              },
            );
          },
        );
      }),
    );
  }
}
