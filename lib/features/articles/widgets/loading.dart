import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

import '../../../shared/extensions/context_ext.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: context.colorScheme.primaryContainer,
        ),
        child: ExpressiveLoadingIndicator(
          color: context.colorScheme.primary,
          polygons: [
            MaterialShapes.softBurst,
            MaterialShapes.pill,
            MaterialShapes.pentagon,
            MaterialShapes.circle,
            MaterialShapes.square,
            MaterialShapes.slanted,
            MaterialShapes.arch,
            MaterialShapes.semiCircle,
            MaterialShapes.triangle,
          ],
        ),
      ),
    );
  }
}
