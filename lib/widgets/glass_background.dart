import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GlassBackground extends StatefulWidget {
  final Widget child;
  final bool isBlindMode;
  final Duration transitionDuration;

  const GlassBackground({
    super.key,
    required this.child,
    this.isBlindMode = false,
    this.transitionDuration = const Duration(milliseconds: 800),
  });

  @override
  State<GlassBackground> createState() => _GlassBackgroundState();
}

class _GlassBackgroundState extends State<GlassBackground>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOutCubic,
    ));

    _colorAnimation = ColorTween(
      begin: const Color(0xFF1A1A2E),
      end: widget.isBlindMode ? const Color(0xFF000000) : const Color(0xFF1A1A2E),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOutCubic,
    ));

    _transitionController.forward();
  }

  @override
  void didUpdateWidget(GlassBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isBlindMode != widget.isBlindMode) {
      _animateTransition();
    }
  }

  void _animateTransition() {
    _colorAnimation = ColorTween(
      begin: widget.isBlindMode ? const Color(0xFF1A1A2E) : const Color(0xFF000000),
      end: widget.isBlindMode ? const Color(0xFF000000) : const Color(0xFF1A1A2E),
    ).animate(CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOutCubic,
    ));

    _transitionController.reset();
    _transitionController.forward();
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isBlindMode) {
      return _buildBlindModeBackground();
    }

    return AnimatedBuilder(
      animation: _transitionController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _colorAnimation.value ?? const Color(0xFF1A1A2E),
                const Color(0xFF16213E),
                const Color(0xFF0F3460),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated background particles
              ...List.generate(20, (index) => _buildBackgroundParticle(index)),
              // Glassmorphic overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.purpleAccent.withValues(alpha: 0.02),
                    ],
                  ),
                ),
              ),
              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: widget.child,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBackgroundParticle(int index) {
    final random = (index * 37) % 100; // Pseudo-random based on index
    final size = 20.0 + (random % 40);
    final left = (random * 3.7) % MediaQuery.of(context).size.width;
    final top = (random * 7.3) % MediaQuery.of(context).size.height;
    final duration = 3000 + (random * 20);

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.purpleAccent.withValues(alpha: 0.1),
              Colors.transparent,
            ],
          ),
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .fadeIn(duration: Duration(milliseconds: duration))
          .scale(
            begin: const Offset(0.5, 0.5),
            end: const Offset(1.5, 1.5),
            duration: Duration(milliseconds: duration),
          )
          .moveY(
            begin: 0,
            end: -50,
            duration: Duration(milliseconds: duration),
          ),
    );
  }

  Widget _buildBlindModeBackground() {
    return AnimatedContainer(
      duration: widget.transitionDuration,
      curve: Curves.easeInOutCubic,
      decoration: const BoxDecoration(
        color: Color(0xFF000000), // Pure black background
      ),
      child: widget.child
          .animate()
          .fadeIn(duration: widget.transitionDuration)
          .slideY(
            begin: 0.1,
            duration: widget.transitionDuration,
            curve: Curves.easeOutCubic,
          ),
    );
  }
}

/// Glassmorphic floating action button with neon effects
class GlassFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color glowColor;
  final bool isBlindMode;
  final String? tooltip;

  const GlassFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.glowColor = Colors.purpleAccent,
    this.isBlindMode = false,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    if (isBlindMode) {
      return FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: const Color(0xFFFFFF00),
        tooltip: tooltip,
        child: Icon(
          icon,
          color: const Color(0xFF000000),
          size: 28,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: GlassmorphicContainer(
        width: 56,
        height: 56,
        borderRadius: 28,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            glowColor.withValues(alpha: 0.3),
            glowColor.withValues(alpha: 0.1),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            glowColor.withValues(alpha: 0.8),
            glowColor.withValues(alpha: 0.4),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onPressed,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
                shadows: [
                  Shadow(
                    color: glowColor.withValues(alpha: 0.8),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 300.ms,
          curve: Curves.easeOutBack,
        )
        .then()
        .shimmer(
          duration: 2000.ms,
          color: glowColor.withValues(alpha: 0.3),
        );
  }
}

/// Performance-optimized glassmorphic container
class OptimizedGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final bool enableShadow;

  const OptimizedGlassContainer({
    super.key,
    required this.child,
    required this.width,
    this.height,
    this.borderRadius = 20,
    this.blur = 15,
    this.backgroundColor,
    this.gradientColors,
    this.enableShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: enableShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: blur * 0.5,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors ??
                  [
                    backgroundColor?.withValues(alpha: 0.2) ??
                        Colors.white.withValues(alpha: 0.15),
                    backgroundColor?.withValues(alpha: 0.1) ??
                        Colors.white.withValues(alpha: 0.05),
                  ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}