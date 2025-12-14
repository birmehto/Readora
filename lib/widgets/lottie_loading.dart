import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/constants/app_spacing.dart';
import '../core/constants/app_typography.dart';

class LottieLoading extends StatelessWidget {
  final String? message;
  final double? size;

  const LottieLoading({super.key, this.message, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Use a simple animated container as fallback since we don't have Lottie files
          Container(
            width: size ?? 120.w,
            height: size ?? 120.h,
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Icon(
                    Icons.article_outlined,
                    size: 48.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          if (message != null) ...[
            SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: AppTypography.bodyMedium(context).copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class ArticleLoadingAnimation extends StatefulWidget {
  final String? message;

  const ArticleLoadingAnimation({super.key, this.message});

  @override
  State<ArticleLoadingAnimation> createState() =>
      _ArticleLoadingAnimationState();
}

class _ArticleLoadingAnimationState extends State<ArticleLoadingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.article_outlined,
                      size: 40.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: AppSpacing.lg),
          if (widget.message != null)
            Text(
              widget.message!,
              style: AppTypography.bodyMedium(context).copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
