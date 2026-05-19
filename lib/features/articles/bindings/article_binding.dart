import 'package:get/get.dart';

import '../presentation/controllers/article_controller.dart';

class ArticleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleController>(() => ArticleController());
  }
}
