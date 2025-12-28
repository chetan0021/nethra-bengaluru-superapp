import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/live_context.dart';

class GlassMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isBlindMode;
  final VoidCallback? onTap;

  const GlassMessageBubble({
    super.key,
    required this.message,
    this.isBlindMode = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // In blind mode, use high contrast design without glassmorphism
    if (isBlindMode) {
      return _buildBlindModeMessage(context);
    }

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: _buildGlassmorphicBubble(context),
        ),
      ),
    );
  }

  Widget _buildGlassmorphicBubble(BuildContext context) {
    final isUser = message.isUser;
    
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 60, // Minimum height for small messages
        maxHeight: 200, // Maximum height to prevent overflow
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isUser
              ? [
                  Colors.purpleAccent.withValues(alpha: 0.2),
                  Colors.purpleAccent.withValues(alpha: 0.1),
                ]
              : [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
          stops: const [0.1, 1],
        ),
        border: Border.all(
          color: isUser
              ? Colors.purpleAccent.withValues(alpha: 0.6)
              : Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Message content with neon glow effect - scrollable for long text
            Flexible(
              child: Container(
                constraints: const BoxConstraints(
                  maxHeight: 140, // Limit height to prevent overflow
                ),
                decoration: BoxDecoration(
                  boxShadow: isUser
                      ? [
                          BoxShadow(
                            color: Colors.purpleAccent.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: SingleChildScrollView(
                  child: Text(
                    message.content,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      height: 1.4,
                      shadows: isUser
                          ? [
                              Shadow(
                                color: Colors.purpleAccent.withValues(alpha: 0.5),
                                blurRadius: 4,
                              ),
                            ]
                          : null,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Timestamp with subtle glow
            Text(
              message.formattedTime,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, curve: Curves.easeOutCubic)
        .slideX(
          begin: isUser ? 0.3 : -0.3,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        )
        .then()
        .shimmer(
          duration: 2000.ms,
          color: isUser 
              ? Colors.purpleAccent.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
        );
  }

  Widget _buildBlindModeMessage(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: message.isUser 
                  ? const Color(0xFFFFFF00) // Bright yellow for user
                  : const Color(0xFF333333), // Dark gray for assistant
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFFF00),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // High contrast message content
                Semantics(
                  label: '${message.isUser ? 'You said' : 'Nethra replied'}: ${message.content}',
                  child: Text(
                    message.content,
                    style: GoogleFonts.poppins(
                      fontSize: 20, // Larger text for accessibility
                      fontWeight: FontWeight.w600,
                      color: message.isUser 
                          ? const Color(0xFF000000) // Black text on yellow
                          : const Color(0xFFFFFF00), // Yellow text on dark
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // High contrast timestamp
                Semantics(
                  label: 'Sent at ${message.formattedTime}',
                  child: Text(
                    message.formattedTime,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: message.isUser 
                          ? const Color(0xFF000000).withValues(alpha: 0.7)
                          : const Color(0xFFFFFF00).withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Enhanced glassmorphic container with neon glow effects
class NeonGlassContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double? height;
  final Color glowColor;
  final double glowIntensity;
  final bool animate;

  const NeonGlassContainer({
    super.key,
    required this.child,
    required this.width,
    this.height,
    this.glowColor = Colors.purpleAccent,
    this.glowIntensity = 0.3,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // Outer glow
          BoxShadow(
            color: glowColor.withValues(alpha: glowIntensity),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          // Inner glow
          BoxShadow(
            color: glowColor.withValues(alpha: glowIntensity * 0.5),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: GlassmorphicContainer(
        width: width,
        height: height ?? 60, // Provide default height
        borderRadius: 20,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.05),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            glowColor.withValues(alpha: 0.6),
            glowColor.withValues(alpha: 0.2),
          ],
        ),
        child: child,
      ),
    );

    if (animate) {
      return container
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(
            duration: 3000.ms,
            color: glowColor.withValues(alpha: 0.1),
          )
          .then()
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.1, 1.1),
            duration: 2000.ms,
          );
    }

    return container;
  }
}

/// Glassmorphic loading indicator with neon effects
class GlassLoadingIndicator extends StatelessWidget {
  final String message;
  final bool isBlindMode;

  const GlassLoadingIndicator({
    super.key,
    this.message = 'Nethra is thinking...',
    this.isBlindMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isBlindMode) {
      return _buildBlindModeLoader();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NeonGlassContainer(
            width: 60,
            height: 60,
            glowColor: Colors.purpleAccent,
            glowIntensity: 0.4,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          NeonGlassContainer(
            width: 200,
            height: 40,
            glowColor: Colors.purpleAccent,
            glowIntensity: 0.2,
            child: Center(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.purpleAccent.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlindModeLoader() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFF000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              color: const Color(0xFFFFFF00),
              backgroundColor: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 24),
          Semantics(
            label: message,
            child: Text(
              message.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFFFFF00),
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}