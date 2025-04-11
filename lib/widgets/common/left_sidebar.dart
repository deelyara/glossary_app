import 'package:flutter/material.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey.shade700; // Define icon color

    return Container(
      width: 60, // Adjust width as needed
      color: const Color(0xFFEEF1F8), // Updated background color
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          _buildSidebarButton(icon: Icons.home_outlined, tooltip: 'Home', color: iconColor),
          _buildSidebarButton(icon: Icons.folder_copy_outlined, tooltip: 'Projects', color: iconColor), // More accurate folder icon
          _buildSidebarButton(icon: Icons.ios_share_outlined, tooltip: 'Share', color: iconColor), // iOS style share
          const Spacer(), // Pushes bottom icons down
          _buildSidebarButton(icon: Icons.apps_outlined, tooltip: 'Apps/Widgets', color: iconColor), // Different widgets icon
          _buildSidebarButton(icon: Icons.toggle_on_outlined, tooltip: 'Toggle', color: iconColor), // Keep toggle
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