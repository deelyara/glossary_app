import 'package:flutter/material.dart';

// This is a workaround for the logo image
// Instead of using an asset, we'll create a simple logo widget
class LogoPlaceholder extends StatelessWidget {
  final double height;
  
  const LogoPlaceholder({super.key, this.height = 36});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'Easyling',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
} 