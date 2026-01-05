import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Always active as requested)
  static const Color whatsappGreen = Color(0xFF25D366); 
  static const Color youtubeRed = Color(0xFFFF0000);
  
  // Neutral/Modern Palette
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color outline = Color(0xFFE0E0E0);
  
  // Action Colors
  static const Color primary = whatsappGreen; // WhatsApp green for primary buttons
  static const Color error = youtubeRed;      // YouTube red for error states
  static const Color onPrimary = Colors.white;
  static const Color onError = Colors.white;
  
  // Additional Material colors for consistency
  static const Color surfaceVariant = Color(0xFFF1F3F4);
  static const Color onSurfaceVariant = Color(0xFF626466);
}