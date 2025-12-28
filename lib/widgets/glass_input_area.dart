import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:avatar_glow/avatar_glow.dart';

class GlassInputArea extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onVoiceStart;
  final VoidCallback onVoiceStop;
  final bool isListening;
  final bool isBlindMode;
  final String hintText;

  const GlassInputArea({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onVoiceStart,
    required this.onVoiceStop,
    this.isListening = false,
    this.isBlindMode = false,
    this.hintText = 'Ask about Bengaluru...',
  });

  @override
  State<GlassInputArea> createState() => _GlassInputAreaState();
}

class _GlassInputAreaState extends State<GlassInputArea> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isBlindMode) {
      return _buildBlindModeInput();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildGlassTextField(),
          ),
          const SizedBox(width: 12),
          _buildGlassVoiceButton(),
        ],
      ),
    );
  }

  Widget _buildGlassTextField() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 56,
      borderRadius: 28,
      blur: 15,
      alignment: Alignment.bottomCenter,
      border: _isFocused ? 2 : 1,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: _isFocused ? 0.25 : 0.15),
          Colors.white.withValues(alpha: _isFocused ? 0.1 : 0.05),
        ],
        stops: const [0.1, 1],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: _isFocused
            ? [
                Colors.purpleAccent.withValues(alpha: 0.8),
                Colors.purpleAccent.withValues(alpha: 0.3),
              ]
            : [
                Colors.white.withValues(alpha: 0.4),
                Colors.white.withValues(alpha: 0.1),
              ],
      ),
      child: Container(
        decoration: _isFocused
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              )
            : null,
        child: TextField(
          controller: widget.controller,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            shadows: [
              Shadow(
                color: Colors.white.withValues(alpha: 0.3),
                blurRadius: 2,
              ),
            ],
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white60,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withValues(alpha: 0.8),
                    Colors.purpleAccent.withValues(alpha: 0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purpleAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: widget.onSend,
                icon: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.8, 0.8),
                  duration: 200.ms,
                  curve: Curves.easeOutCubic,
                )
                .then()
                .shimmer(
                  duration: 2000.ms,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
          ),
          onSubmitted: (_) => widget.onSend(),
          onTap: () => setState(() => _isFocused = true),
          onTapOutside: (_) => setState(() => _isFocused = false),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.3, duration: 300.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildGlassVoiceButton() {
    return AvatarGlow(
      animate: widget.isListening,
      glowColor: widget.isListening ? Colors.red : Colors.purpleAccent,
      duration: const Duration(milliseconds: 2000),
      repeat: true,
      endRadius: 45.0,
      curve: Curves.fastOutSlowIn,
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
          colors: widget.isListening
              ? [
                  Colors.red.withValues(alpha: 0.8),
                  Colors.red.withValues(alpha: 0.6),
                ]
              : [
                  Colors.purpleAccent.withValues(alpha: 0.8),
                  Colors.purpleAccent.withValues(alpha: 0.6),
                ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isListening
              ? [
                  Colors.red.withValues(alpha: 0.9),
                  Colors.red.withValues(alpha: 0.4),
                ]
              : [
                  Colors.purpleAccent.withValues(alpha: 0.9),
                  Colors.purpleAccent.withValues(alpha: 0.4),
                ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: (widget.isListening ? Colors.red : Colors.purpleAccent)
                    .withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
          child: IconButton(
            onPressed: widget.isListening ? widget.onVoiceStop : widget.onVoiceStart,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                widget.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                key: ValueKey(widget.isListening),
                color: Colors.white,
                size: 24,
                shadows: [
                  Shadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate()
          .scale(
            begin: const Offset(0.8, 0.8),
            duration: 200.ms,
            curve: Curves.easeOutCubic,
          )
          .then()
          .shimmer(
            duration: 1500.ms,
            color: widget.isListening ? Colors.red.withValues(alpha: 0.3) : Colors.purpleAccent.withValues(alpha: 0.3),
          ),
    );
  }

  Widget _buildBlindModeInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF000000),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFFF00),
                  width: 2,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFFF00),
                ),
                decoration: InputDecoration(
                  hintText: widget.hintText.toUpperCase(),
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFFFFF00).withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFF00),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      onPressed: widget.onSend,
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Color(0xFF000000),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                onSubmitted: (_) => widget.onSend(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // High contrast voice button
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: widget.isListening 
                  ? const Color(0xFFFF0000) 
                  : const Color(0xFFFFFF00),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFFF00),
                width: 3,
              ),
            ),
            child: IconButton(
              onPressed: widget.isListening ? widget.onVoiceStop : widget.onVoiceStart,
              icon: Semantics(
                label: widget.isListening 
                    ? 'Stop voice recording' 
                    : 'Start voice recording',
                child: Icon(
                  widget.isListening ? Icons.stop_rounded : Icons.mic_rounded,
                  color: widget.isListening 
                      ? const Color(0xFFFFFF00) 
                      : const Color(0xFF000000),
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Glassmorphic app bar with neon effects
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBlindMode;
  final List<Widget>? actions;

  const GlassAppBar({
    super.key,
    required this.title,
    this.isBlindMode = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    if (isBlindMode) {
      return AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        title: Text(
          title.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFFFFF00),
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        actions: actions,
      );
    }

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withValues(alpha: 0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          borderRadius: 0,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 0,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
            stops: const [0.1, 1],
          ),
          borderGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.transparent, Colors.transparent],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.purpleAccent.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .then()
                .shimmer(
                  duration: 3000.ms,
                  color: Colors.purpleAccent.withValues(alpha: 0.2),
                ),
            centerTitle: true,
            actions: actions,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}