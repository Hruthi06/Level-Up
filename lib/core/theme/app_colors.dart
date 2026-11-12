import 'package:flutter/material.dart';

class AppColors {
  // Primary dark canvases
  static const Color background = Color(0xFF0A0A0C);
  static const Color surface = Color(0xFF16161A);
  static const Color surfaceElevated = Color(0xFF1F1F26);
  static const Color surfaceCard = Color(0xFF18181E);
  static const Color border = Color(0xFF282832);
  static const Color borderGlow = Color(0xFF00FF66);

  // Neon Game Accents
  static const Color neonLime = Color(0xFF00FF66);
  static const Color neonLimeDark = Color(0xFF00C853);
  static const Color neonEmerald = Color(0xFF059669);
  static const Color electricCyan = Color(0xFF00E5FF);
  static const Color streakOrange = Color(0xFFFF9900);
  static const Color alertRed = Color(0xFFFF3366);
  static const Color mythicPurple = Color(0xFFA855F7);
  static const Color gold = Color(0xFFFFD700);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textDisabled = Color(0xFF475569);

  // Gradients
  static const LinearGradient neonGreenGradient = LinearGradient(
    colors: [neonLime, Color(0xFF00D26A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1A1A22), Color(0xFF141418)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1E2822), Color(0xFF121415)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [Color(0xFFFF9900), Color(0xFFFF5500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

