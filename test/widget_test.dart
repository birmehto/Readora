import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:readora/app.dart';
import 'package:readora/core/services/clipboard_service.dart';
import 'package:readora/core/services/share_intent_service.dart';
import 'package:readora/core/services/storage_service.dart';

// A minimal mock for StorageService to satisfy dependencies during widget testing
class MockStorageService extends StorageService {
  @override
  bool get isDarkMode => false;
  @override
  double get fontSize => 16.0;
  @override
  String get fontFamily => 'Inter';
  @override
  List<dynamic> get favorites => [];
}

class MockShareIntentService extends ShareIntentService {
  @override
  Future<ShareIntentService> init() async => this;
}

class MockClipboardService extends ClipboardService {}

void main() {
  setUp(() {
    Get.reset();
    Get.put<StorageService>(MockStorageService());
    Get.put<ShareIntentService>(MockShareIntentService());
    Get.put<ClipboardService>(MockClipboardService());
  });

  testWidgets('App launches successfully', (tester) async {
    // Set screen size for ScreenUtil
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(const Readora());
    
    // Pump first frame
    await tester.pump();
    
    // Advance virtual time by 10 seconds to allow any one-off timers/delays (e.g. from ScreenUtil) to complete
    await tester.pump(const Duration(seconds: 10));

    // Verify Readora is rendered
    expect(find.byType(Readora), findsOneWidget);
    
    // Clear screen size override
    addTearDown(tester.view.resetPhysicalSize);
  });
}
