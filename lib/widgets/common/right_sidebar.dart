import 'package:flutter/material.dart';

class RightSidebar extends StatelessWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey.shade700; // Define icon color

    return Container(
      width: 60, // Adjust width as needed
      color: const Color(0xFFF8F9FF), // Updated background color
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          _buildSidebarButton(icon: Icons.edit_outlined, tooltip: 'Edit', color: iconColor),
          _buildSidebarButton(icon: Icons.settings_outlined, tooltip: 'Settings', color: iconColor),
          _buildSidebarButton(icon: Icons.info_outline, tooltip: 'Info', color: iconColor),
        ],
      ),
    );
  }

  // Helper widget for consistent button styling
  Widget _buildSidebarButton({required IconData icon, required String tooltip, Color? color}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {},
      tooltip: tooltip,
      iconSize: 24, // Standard icon size
      color: color, // Use defined color
      splashRadius: 24, // Control splash area
      visualDensity: VisualDensity.compact, // Reduce padding
    );
  }
} 